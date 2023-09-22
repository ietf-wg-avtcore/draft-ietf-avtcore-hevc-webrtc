.\" format this document with "rfc hevc-webrtc-04.nr draft-aboba-avtcore-hevc-webrtc-02.txt"
.nr HY 0
.pl 10.0i
.po 0
.ll 7.2i
.lt 7.2i
.nr LL 7.2i
.nr LT 7.2i
.ds LH INTERNET-DRAFT
.ds CH H.265 Profile for WebRTC
.ds RH \*(DY
.ds LF Aboba, et. al
.ds CF Standards Track
.ds RF FORMFEED[Page %]

.tl 'AVTCORE Working Group''B. Aboba'
.tl 'INTERNET-DRAFT''P. Hancke'
.tl 'Category: Standards Track''Microsoft Corporation'
.tl 'Expires: March 05, 2024''\*(DY'
.ad l
.LP
.LP
.ce
H.265 Profile for WebRTC
.ce
draft-aboba-avtcore-hevc-webrtc-02.txt

Abstract

.in +0.3i
RFC 7742 defines WebRTC video processing and codec requirements, including 
guidance for endpoints supporting the VP8 and H.264 codecs, which are mandatory
to implement.
With support for H.265 under development in WebRTC browsers,
similar guidance is needed for browsers considering support for the
H.265 codec, whose RTP payload format is defined in RFC 7798.
.in -0.3i

Status of This Memo

.in +0.3i
This Internet-Draft is submitted in full conformance with the
provisions of BCP 78 and BCP 79.

Internet-Drafts are working documents of the Internet Engineering
Task Force (IETF).
Note that other groups may also distribute
working documents as Internet-Drafts.  The list of current Internet-
Drafts is at http://datatracker.ietf.org/drafts/current/.

Internet-Drafts are draft documents valid for a maximum of six months
and may be updated, replaced, or obsoleted by other documents at any
time.
It is inappropriate to use Internet-Drafts as reference
material or to cite them other than as "work in progress."

This Internet-Draft will expire on March 05, 2024.
.in -0.3i
.bp
Copyright Notice

.in +0.3i
Copyright (c) 2023 IETF Trust and the persons identified as the
document authors.  All rights reserved.

This document is subject to BCP 78 and the IETF Trust's Legal
Provisions Relating to IETF Documents (https://trustee.ietf.org/
license-info) in effect on the date of publication of this document.
Please review these documents carefully, as they describe your rights
and restrictions with respect to this document.  Code Components
extracted from this document must include Revised BSD License text as
described in Section 4.e of the Trust Legal Provisions and are
provided without warranty as described in the Revised BSD License.
.in -0.3i

Table of Contents

.in +0.3i
.nf
1.  Introduction  . . . . . . . . . . . . . . . . . . . . . . . .   3
  1.1.  Terminology . . . . . . . . . . . . . . . . . . . . . . .   3
2.  H.265 Support . . . . . . . . . . . . . . . . . . . . . . . .   3
3.  Security Considerations . . . . . . . . . . . . . . . . . . .   4
4.  IANA Considerations . . . . . . . . . . . . . . . . . . . . .   4
5. References . . . . . . . . . . . . . . . . . . . . . . . . . .   4
  5.1.  Normative References  . . . . . . . . . . . . . . . . . .   4
  5.2.  Informative References  . . . . . . . . . . . . . . . . .   5
Acknowledgments   . . . . . . . . . . . . . . . . . . . . . . . .   5
Authors' Addresses  . . . . . . . . . . . . . . . . . . . . . . .   5
.fi
.in -0.3i
.bp
.NH 1
.R
Introduction

.in +0.3i
"RTP Payload Format for High Efficiency Video Coding (HEVC)" [RFC7798] defines 
the encapsulation of H.265 [H.265] within the Real-time Transport Protocol (RTP) [RFC3550]. 
While "WebRTC Video Processing and Codec Requirements" [RFC7742] provides
guidance for endpoints supporting the mandatory to implement VP8 and H.264 codecs,
it does not cover H.265. With H.265 support under development within browsers [HEVC-WebKit][HEVC-Chrome]
there is a need to for an interoperability profile of [RFC7798] for WebRTC implementations choosing to support
H.265.
.in -0.3i
.NH 2
.R
Terminology

.in +0.3i
The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and
"OPTIONAL" in this document are to be interpreted as described in
BCP 14 [RFC2119] [RFC8174] when, and only when, they appear in all
capitals, as shown here.
.in -0.3i
.NH 1
.R
H.265 Support

.in +0.3i
Support for the H.265 video codec is OPTIONAL for WebRTC browsers and non-browsers.
Implementations supporting H.265 that conform to this specification MUST support
receiving H.265 and MAY support sending H.265. 

For the H.265 [H.265] codec, endpoints MUST support the payload formats
defined in [RFC7798]. In addition, they MUST support Main Profile
Level 3.1 (level-id=93) and SHOULD support Main Profile Level 4 (level-id=120).

[RFC7798] Section 4.5 defines how Temporal Scalability Control Information (TSCI)
is communicated using PACI Extensions defined in [RFC7798] Section 4.4.4.2.
When WebRTC implementations negotiate the use of RTP header extensions containing
TSCI information, such as the Dependency Descriptor [DD], the TSCI information
contained in the RTP header extensions takes precedence and implementations
MUST ignore TSCI information contained in the PACI.

Implementations of the H.265 codec have utilized a wide variety of
optional parameters.  To improve interoperability, the following
parameter settings are specified:

level-id: Implementations SHOULD include this parameter within SDP and
MUST interpret it when receiving it. If no level-id is present, a
value of 93 (i.e., level 3.1) MUST be inferred.

max-fps, max-cpb, max-dpb, and max-br:

These parameters allow the implementation to specify that they can
support certain features of H.265 at higher rates and values than
those signaled by their level (set with level-id).
Implementations MAY include these parameters in their SDP, but
they SHOULD interpret them when receiving them, allowing them to
send the highest quality of video possible.

sprop-sps, sprop-pps, sprop-vps, sprop-sei: H.265 allows sequence and picture information
to be sent both in-band and out-of-band.  WebRTC implementations
MUST signal this information in-band.  This means that WebRTC
implementations MUST NOT include these parameters in the SDP they
generate, and SHOULD silently ignore these parameters if they
are received..

When the use of the video orientation (CVO) RTP header extension is
not signaled as part of the SDP, H.265 implementations MAY send and
SHOULD support proper interpretation of Display Orientation SEI
messages.

Unless otherwise signaled, WebRTC implementations that support H.265 MUST encode
and decode pixels with an implied 1:1 (square) aspect ratio.
.in -0.3i
.NH 1
.R
Security Considerations

.in +0.3i
This document is subject to the security considerations described in
Section 7 of [RFC7742].

In addition to those security considerations, H.265 implementers
are advised to take note of the "Security Considerations" Section 9
of [RFC7798], including requirements pertaining to SEI messages.
.in -0.3i
.NH 1
.R
IANA Considerations

.in +0.3i
This document does not require actions by IANA.
.in -0.3i
.NH 1
.R
References
.NH 2
.R
Normative References
.IP [DD] 15
Alliance for Open Media (AoMedia), "Dependency Descriptor RTP Header Extension",
https://aomediacodec.github.io/av1-rtp-spec/#dependency-descriptor-rtp-header-extension,
retrieved September 19, 2023.
.IP [H.265]
ITU-T, "High efficiency video coding", ITU-T Recommendation H.265, April 2013.
.IP [RFC2119]
Bradner, S., "Key words for use in RFCs to Indicate
Requirement Levels", BCP 14, RFC 2119,
DOI 10.17487/RFC2119, March 1997,
<https://www.rfc-editor.org/info/rfc2119>.
.IP [RFC3550]
Schulzrinne, H., Casner, S., Frederick, R., and V.
Jacobson, "RTP: A Transport Protocol for Real-Time
Applications", STD 64, RFC 3550, DOI 10.17487/RFC3550,
July 2003, <https://www.rfc-editor.org/info/rfc3550>.
.IP [RFC7742]
Roach, A. B., "WebRTC Video Processing and Codec Requirements",
RFC 7742, DOI 10.17487/RFC7742, March 2016,
<https://www.rfc-editor.org/info/rfc7742>.
.IP [RFC7798]
Wang, Y.K., Sanchez, Y., Schierl, T., Wenger, S. and M. M. Hannuksela,
"RTP Payload Format for High Efficiency Video Coding (HEVC)",
RFC 7798, DOI 10.17487/RFC7798, March 2016,
<https://www.rfc-editor.org/info/rfc7798>. 
.IP [RFC8174]
Leiba, B., "Ambiguity of Uppercase vs Lowercase in RFC 2119 Key Words",
RFC 8174, DOI 10.17487/RFC8174, May 2017,
<https://www.rfc-editor.org/info/rfc8174>.
.NH 2
.R
Informative References
.IP [HEVC-WebKit] 15
Shin, S. Qiu, J. and J. Zhu, "WebRTC HEVC RFC 7798 RTP Payload Format Implementation",
https://github.com/WebKit/WebKit/pull/15494 (work in progress),
retrieved July 9, 2023.
.IP [HEVC-Chrome]
"Issue 13485: Need the support of H.265", 
https://bugs.chromium.org/p/webrtc/issues/detail? id=13485 (work in progress),
submitted December 8, 2021.
.LP
Acknowledgments

.in +0.3i
We would like to thank Stephan Wenger, Jonathan Lennox, Harald Alvestrand,
Jianlin Qiu and Philip Eliasson for their discussions of this problem space.
.in -0.3i

Authors' Addresses

.in +0.3i
.nf
Bernard Aboba
Microsoft Corporation
One Microsoft Way
Redmond, WA  98052
United States of America

Email:  bernard.aboba@gmail.com

Philipp Hancke
Microsoft Corporation
Talinn, Estonia

Email: philipp.hancke@gmail.com 
.fi
.in -0.3i
