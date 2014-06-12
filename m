Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbaFLL1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:27:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38354 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726AbaFLL1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:27:37 -0400
Date: Thu, 12 Jun 2014 12:27:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Dooks <ben@simtec.co.uk>, Brian W Hart <hartb@linux.vnet.ibm.com>,
        Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Christian Engelmayer <cengelma@gmx.at>,
        Christopher Brannon <chris@the-brannons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Jiri Kosina <jkosina@suse.cz>, Lindar Liu <lindar_liu@usish.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Simon Wood <simon@mungewell.org>, Vincent Sanders <vince@simtec.co.uk>
Message-ID: <20140612112715.GX5099@sirena.org.uk>
References: <877g4oau2s.fsf@rustcorp.com.au>
 <20140611105503.GG5099@sirena.org.uk>
 <87y4x2q5qr.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WgdQfrgc+EMoNxea"
Content-Disposition: inline
In-Reply-To: <87y4x2q5qr.fsf@rustcorp.com.au>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PULL] modules-next
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WgdQfrgc+EMoNxea
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 12, 2014 at 10:55:00AM +0930, Rusty Russell wrote:
> Mark Brown <broonie@kernel.org> writes:

> > if you need to respin - please do send patches to maintainers.

> If the address in drivers/regulator/virtual.c is incorrect, please
> update it:

>  Subject: [PATCH 5/9] drivers/regulator/virtual: avoid world-writable sysfs files.
>  To: linux-kernel@vger.kernel.org
>  Cc: Rusty Russell <rusty@rustcorp.com.au>, Mark Brown <broonie@opensource.wolfsonmicro.com>
>  Date: Tue, 22 Apr 2014 13:03:28 +0930

The main people to hit are subsystem maintainers - driver authors have
often vanished or don't really respond to upstream e-mail, though of
course they should also be included.

--WgdQfrgc+EMoNxea
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTmY6PAAoJELSic+t+oim9/CwQAJfIly2vIlL4KK6yWrz6+yhz
lOKDmgr3qbyr8M6GoUHBzX3l21VJO0o7uVlyNIpxwOjxiubM2ryiEt/OsCoWmXKT
wwKmyPGES23EBnht3yMBG6Ig8XGluhu58CjSnvjZRL/7q29tTWKHIQo6x6Lddm5r
ZR+DgYzpe48E84Ipe2wHZX8SIEzJUAjBFhpJYBzCgk3isZUJXEJ3eeVgdb9FZW0T
G6E9Upjf/KPJcQalWKPQfw65TM2SAfxgwv2z/h+YwwPLBq6x04EMb/G1Fb9FKy2Z
O8U3pFLSAnbr3VbP0P2q94gTtCr9rfvZ9l9Naoho2XSQQ8mAzoJaPH7UKhcm23qA
68mP171m+u7TSpNFBanX+Q2lqS/xSfS6wbMrd+3tmOGHRZ5KT61z7z5txQI3YKrc
vxXBE+B4AGLIdunVKlAupk3fO1pau7RuVNnbY/DHl7gh/ZLkCTs4qoZDMMUpcAP4
ndKgnVtkhP/flN7cPwnUnoolLq7W6LfILUwFKpW2oaD/MzjScHK4OcoFglnJEEp0
hiVZhec7+nauwsI1MbJqmknRsskNbmw0kSNQi9ZJ6bD2DeDNNJDDaatSy2qeEWDC
bfOXN3P6T/ajdv0FWPsD5eEyZ9Hqo5X9oFKzphLPQNOEnXJ3mNs+/dOdz49COYQ9
seWRs3BKyN8w+a3mAkmo
=1N5u
-----END PGP SIGNATURE-----

--WgdQfrgc+EMoNxea--
