Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbbAWQxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:53:09 -0500
Received: from butterbrot.org ([176.9.106.16]:57978 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbbAWQxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:53:07 -0500
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Jan 2015 11:53:07 EST
Message-ID: <54C27AE4.4020702@butterbrot.org>
Date: Fri, 23 Jan 2015 17:46:28 +0100
From: Florian Echtler <floe@butterbrot.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: "Baluta, Teodora" <teodora.baluta@intel.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jonathan Cameron <jic23@kernel.org>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-iio <linux-iio@vger.kernel.org>,
        LMML <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 0/3] Introduce IIO interface for fingerprint sensors
References: <1417698017-13835-1-git-send-email-teodora.baluta@intel.com> <5481153B.4070609@kernel.org> <1418047828.18463.10.camel@bebop> <54930604.1020607@metafoo.de> <549D42BD.1050901@kernel.org> <1421255642.31900.4.camel@bebop> <54B7FAF2.8080207@samsung.com> <A2E3DE9C026DE6469D89C3A4C6C219390A89FE37@IRSMSX107.ger.corp.intel.com>
In-Reply-To: <A2E3DE9C026DE6469D89C3A4C6C219390A89FE37@IRSMSX107.ger.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="nS1pCTG5i2HEopfJ57PrmSaElcWIb8gne"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nS1pCTG5i2HEopfJ57PrmSaElcWIb8gne
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello Teodora,

On 23.01.2015 14:05, Baluta, Teodora wrote:
> The fingerprint sensor acts more like a scanner device, so the
> closest type is the V4L2_CAP_VIDEO_CAPTURE. However, this is not a
> perfect match because the driver only sends an image, once, when
> triggered. Would it be a better alternative to define a new
> capability type? Or it would be acceptable to simply have a video
> device with no frame buffer or frame rate and the user space
> application to read from the character device /dev/videoX?
Sorry if I jump in here right in the middle of this discussion, but some
time ago, I wrote a fingerprint sensor driver for the Siemens ID Mouse
(still part of the kernel AFAICT) which acts as a misc device and just
creates a character device node that can be used to directly read a PGM
file.

Maybe this would be a slightly simpler approach than pulling in all the
streaming-optimized features of V4L2?

Best, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--nS1pCTG5i2HEopfJ57PrmSaElcWIb8gne
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlTCeuQACgkQ7CzyshGvatjWsgCdHyNxoUEdkJhMapuv1VzNOWrC
MPoAoPlq+IDgg2aCbLrxWFpQWI7KQgk1
=R3Ri
-----END PGP SIGNATURE-----

--nS1pCTG5i2HEopfJ57PrmSaElcWIb8gne--
