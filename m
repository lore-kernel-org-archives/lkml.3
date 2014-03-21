Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbaCUGIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 02:08:46 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:61841 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaCUGIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 02:08:45 -0400
Message-ID: <532BD764.9060409@monstr.eu>
Date: Fri, 21 Mar 2014 07:08:36 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Paul Bolle <pebolle@tiscali.nl>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] MAINTAINERS: microblaze: Use LKML as mailing list
References: <4f187754982226c3456c0a9b86050ab4e470aa98.1395328176.git.michal.simek@xilinx.com>  <1395346547.29055.2.camel@x220> <1395346718.7776.43.camel@joe-AO722>
In-Reply-To: <1395346718.7776.43.camel@joe-AO722>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="akaGDjdkTeUhEVe2jAjphRR2iUKAwJ19k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--akaGDjdkTeUhEVe2jAjphRR2iUKAwJ19k
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/20/2014 09:18 PM, Joe Perches wrote:
> On Thu, 2014-03-20 at 21:15 +0100, Paul Bolle wrote:
>> On Thu, 2014-03-20 at 16:09 +0100, Michal Simek wrote:
>>> microblaze-uclinux mailing list is almost dead and
>>> it is just causing troubles for non subscribers which are
>>> getting email about waiting for moderator.
>>> Approval never happens. Move it to LKML.
> []
>>> diff --git a/MAINTAINERS b/MAINTAINERS
> []
>>> @@ -5702,7 +5702,7 @@ F:	fs/imgdafs/
>>>
>>>  MICROBLAZE ARCHITECTURE
>>>  M:	Michal Simek <monstr@monstr.eu>
>>> -L:	microblaze-uclinux@itee.uq.edu.au (moderated for non-subscribers)=

>>> +L:	linux-kernel@vger.kernel.org
>>
>> Isn't lkml already the catch all address that get_maintainer.pl always=

>> spits out?
>=20
> 'tis.
>=20
> My preference is not adding L: lkml lines to
> individual sections as it is the default and it is
> specified as such in the beginning of MAINTAINERS
> and SubmittingPatches.

Ok. No problem will send v2.

Maybe good to remove others too.
[linux]$ grep linux-kernel@vger.kernel.org MAINTAINERS  | wc -l
24

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--akaGDjdkTeUhEVe2jAjphRR2iUKAwJ19k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMr12QACgkQykllyylKDCEyFwCfZhho7dBRLGIfGKU+RF34QiCE
hZYAn1A4oN+yTOYerlmX8ycfqgVqS5Dy
=qPtu
-----END PGP SIGNATURE-----

--akaGDjdkTeUhEVe2jAjphRR2iUKAwJ19k--
