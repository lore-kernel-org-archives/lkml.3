Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaCAENj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 23:13:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53906 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaCAENh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 23:13:37 -0500
Date: Sat, 1 Mar 2014 13:13:30 +0900
From: Mark Brown <broonie@kernel.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: iivanov@mm-sol.com, gsi@denx.de, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140301041330.GO29849@sirena.org.uk>
References: <1393596196-8652-1-git-send-email-anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5G50dybFf3pRZKd7"
Content-Disposition: inline
In-Reply-To: <1393596196-8652-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.126.181.238
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: core: make zero length transfer valid again
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5G50dybFf3pRZKd7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 28, 2014 at 11:03:16PM +0900, Atsushi Nemoto wrote:
> Zero length transfer becomes invalid since
> "spi: core: Validate length of the transfers in message" commit,
> but it should be valid to support an odd device, for example, which
> requires long delay between chipselect and the first transfer, etc.

Applied, thanks.

--5G50dybFf3pRZKd7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTEV5nAAoJELSic+t+oim9dhgP/2fxY+yLfTtA0VJGxzFbxKKh
ncJjiPyxTteX7uyb14uagXsorSOBHphlIZ8EeUqvOQ1xrOO+njffZLEQAmDnGFBe
JbfB7mylrHG2ZQ+VW4SydyKynG2zzbHzw33PON9SO/OAy1G10IRT6nb+gIKPwJ+J
2BkruE65aTTDIxLXzoOEUu2KcZ6fyWCfSpFb+t9QN7PtB65sVnNZ/TBdtl/fCrKD
iJFghmhbKQ5jErOBb90KfhZI+tVVNOY3ZyK487GcOnXwL+V2FFFRI4N+0JGPqjDT
3I6J58r6BttSJpT7QdGhKbDGqRQOAQpRVde158fQ0nKRMg44BBlyi8Oq56vJripC
joH/U6KoP+cIyxDSHUylLePKVpamQMvIeU8H03RQrViN0MNQbyWP4E/8fZIfCaXI
Lh9TVE3g6hhTdyHPoAU2KNIkKjybOKE2tZ1LcqXXH4reBQ2mu4pAL6YJpaQmsdxQ
n6bbvNpEg+2YizNDsCO2lX5k/JQrl4+i5occ5z8r2FRCYcXvgjDQtNJtA1cJjsq3
JDgjAYyRDrZvPXIoZZX2cwzHu07J+YGnpzrdQUnPYMqI9o38O1ClhcD89QXP6TY0
VP/nckKDigsAQlIst7IlwB9Ty+Brudn+O9KpcPDU01bStiAvkkjfMBK51HgJurHg
jVf7SfRgZ3GPU3FqoypH
=iw+c
-----END PGP SIGNATURE-----

--5G50dybFf3pRZKd7--
