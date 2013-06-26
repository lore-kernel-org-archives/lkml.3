Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab3FZMQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:16:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55585 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3FZMQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:16:35 -0400
Message-ID: <51CADB4A.1080509@ti.com>
Date: Wed, 26 Jun 2013 15:15:06 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/2 v2] fb: fix atyfb unused data warnings
References: <51C26B56.20802@infradead.org> <20130624143737.GI305@game.jcrosoft.org> <51C887CC.6000301@infradead.org>
In-Reply-To: <51C887CC.6000301@infradead.org>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="----enig2QHVIFPSGCXDGRVVLHRRO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2QHVIFPSGCXDGRVVLHRRO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 24/06/13 20:54, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>=20
> Fix compiler warnings of data defined but not used by using the
> __maybe_unused attribute.  The date are only used with certain kconfig
> settings.
>=20
> drivers/video/aty/atyfb_base.c:534:13: warning: 'ram_dram' defined but =
not used [-Wunused-variable]
> drivers/video/aty/atyfb_base.c:535:13: warning: 'ram_resv' defined but =
not used [-Wunused-variable]
>=20

I've added this and the first patch in the series to my fbdev-3.11 branch=
=2E

 Tomi



------enig2QHVIFPSGCXDGRVVLHRRO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRyttKAAoJEPo9qoy8lh71hDAQAIqiUhXMRHDxTMwiiWPcVEy8
s+D+epzZ34+YVAvQvLRrJmX1AldGc8/pbMo5j8DN9dhR/Xr/4Ayh/V06Nd5ffUGc
stp1ElLnviScb4LQtLNQdWQM5w0s4kbbGmzuHOTeaRq/dO1rBSqy1YWuuEQvpAlB
c0qxTxE6vj6J/rctuofpYWHbrwByquWQ0YloBz25bqRcn7GFC7+S/PBrwFMOCW2+
dKdOIkxb88pqv8WAMrHM/C5414knbmASUtpTODYvZ+x1bwDj2l3sPXma4HiBR0xa
O94CZuyIvTC1ucSFCXKAuIOchJQ1Cu36RCO+tPRIFXzovfafPwcTML8xBRxM89VO
AeJAoqaG6YHNA6v9GhwePUfnpxK72zLIC5P0+rDki1t9BSjOUTy8pza26+zxlpB4
nfVTm32dSkjRz9idqoJWmyX7H40wv0hGNtupgK2jhgcy3wfrdHzbuiCHSmXNyc3v
nMUGepiI1JH/O962i4iSfFX7FuE5lu6V4K7GUeyP+0rFoGo/tr+WdWyxEeC6Z91S
8amW33rCWCjMcAuHJlgp9jFGG6LsuBoaZXndzo0BkWs2Kq16PeEKeBDzwcV1l/r1
ZFJ46P9lllPNG4EJRFBqOtt9hLRgOtkD/r8tn1A/36T2CBry0ftIp8bHmz+WH8AF
zV2SSRj5NHYhyHkfIEqy
=CQlm
-----END PGP SIGNATURE-----

------enig2QHVIFPSGCXDGRVVLHRRO--
