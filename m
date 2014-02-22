Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbaBVCnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 21:43:45 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48735 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaBVCnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 21:43:43 -0500
Date: Sat, 22 Feb 2014 11:10:48 +0900
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Message-ID: <20140222021048.GH25940@sirena.org.uk>
References: <1393011432-28909-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1393011432-28909-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wayzTnRSUXKNfBqd"
Content-Disposition: inline
In-Reply-To: <1393011432-28909-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.103.222
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] regmap: Add API call apply but not register a patch
 file
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wayzTnRSUXKNfBqd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 21, 2014 at 07:37:11PM +0000, Charles Keepax wrote:
> This patch provides a new regmap API call that allows a patch to be
> applied but not registered with the regmap core. Common code between
> this and the existing regmap_register_patch function is factored out to
> reduce duplication.

This is just regmap_multi_reg_write() I think?  That already exists, the
theory was that we're going to get an optimised version of that for some
hardware which can stream things and cut out some overheads though that
doesn't seem to have materialised yet.

--wayzTnRSUXKNfBqd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCAclAAoJELSic+t+oim9RWkP/2YaDfVHTReci2ubM76qwyfx
qYhYffiXnPuRdBw1f8KwRQ6aYX7ztWkcGl+d4aGTipnyvMdy0BHzVe0Epojb50UT
nFYEmwE9bs/QrFu/epc/wPXKTVuGPlQWg1fvwkMmMRsV4emWuF/+npBmQSYvfLHb
DYKorMuuEhreREX/VhhnOEGFxcRnTCiyUdo69/y4/Cmqp3RX8lLEvjKMG/Klg1V7
MNGjEy3S8eZp9YgtUUEuSzjIhEvixfN1c5V6muycL0PcIwpYktJBmQrHMbOdnyAK
Vflt6wFvOhxJhJusBczypHrK6QEJYwINh+zBQCHWQKDMMDse3pGnkeYalxoZGv3X
8JggCbpc50i0Qi73vLojLd1TLwxOyl5ixVp9j9WAQSBE+Xu5sYHyQOoydspUuakM
/nPIJ1+efyRZMJqJ0xfv3s4FUWRLG+K8sOPRpmQUmF+iyr4kpcjD5GUsViSf+UPz
lyZNIt+U6nunA6bmnTjgATEm6eiSyXalaWXLaSyuN9tUqLJdjpnURIa4T6m+VqD+
JaAbZTFHmoGWUB4iczw59rq7+DGbIQ+sNjcrr/aAzVRNaCMGKyxaVqEVTqIr4NVh
furR6DgeaEOm946OnC+JOLOiNuHFw0ncUTSNw2Z/copcUod2yx+Eg8cZHsCyoZGV
JfwbpHR+kaLKI4noOikP
=D/WO
-----END PGP SIGNATURE-----

--wayzTnRSUXKNfBqd--
