Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaIXXPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 19:15:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40110 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaIXXPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 19:15:19 -0400
Date: Wed, 24 Sep 2014 18:15:11 -0500
From: Felipe Balbi <balbi@ti.com>
To: Michal Sojka <sojka@merica.cz>
CC: <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        Bryan Wu <cooloney@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.vokac@comap.cz>
Subject: Re: [PATCH v6 3/4] usb: Rename usb-common.c
Message-ID: <20140924231511.GB27672@saruman>
Reply-To: <balbi@ti.com>
References: <Pine.LNX.4.44L0.1409241106100.1580-100000@iolanthe.rowland.org>
 <1411591401-5874-1-git-send-email-sojka@merica.cz>
 <1411591401-5874-4-git-send-email-sojka@merica.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline
In-Reply-To: <1411591401-5874-4-git-send-email-sojka@merica.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2014 at 10:43:20PM +0200, Michal Sojka wrote:
> In the next commit, we will want the usb-common module to be composed of
> two object files. Since Kbuild cannot "append" another object to an
> existing one, we need to rename usb-common.c to something
> else (common.c) and create usb-common.o by linking the wanted objects
> together. Currently, usb-common.o comprises only common.o.
>=20
> Signed-off-by: Michal Sojka <sojka@merica.cz>

for future reference, you can use git format-patch -M -C to detect
renames, the generated diff is far better ;-)

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--CdrF4e02JqNVZeln
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUI1B/AAoJEIaOsuA1yqREQDEQAIO6xxHpF99I7CKrajWdfDOP
1Vkvxu/xtCbx05RsN6cShFIDXmq+lo9gvH/YzxGTqIj0HOoZA4hrQ9pECQolueFg
VrnJXaHChHKVvHRSRZcDtwadIxQu3WbXRLeK/8G1cJlX3pFs9X8O8n4uFtd3QNt8
1yegoy6OLWU+arXgTejcheYW6V6SJX5FIKKdCzvHSJQLPE7Jol4kFdCbuXa1+U3e
2wuqLFSssJRZbFbAMiNess52YQUdy3X7U2459Glzpk5BQ82wUSUsvi+7onkVDNZK
0hDzbwHxpXU1jXWtVRxmjW25wJwY1BCHrOikVtYX0mmUEhlY+bJ2lCTY9EQyBciO
OdsxZJ/Oze+ACDkZLHFXK8HNS+Xy9ZA/GcOP3nIo2UfDo9ITQrt0dpuHO7vi7sLN
RtEy6oxmmIbDVW6l8GfRshrZ976g7gkfMIyKg68kPCeB2/xeT9PKqwLElDb+7y0C
KOl9Tk9iACjOfUKNI0eQlo+Nb60D7AnicGEV93IXKucpUGw1OpDxTOo21bfg3IV9
O/YWClQz4jcVCEXILJjCFN0h2WJRWqFa/FMsZFbWoLpXiD5tQbHJIlLBctTOt1FL
rZxOB5LR/tlgcCNRw4xTBrF+SW4ps9tVrmwkKGNuw7AjdhSmWfavOQ2sZqMZrwqV
f1CfOkY5iFpEqSM5op1c
=cre3
-----END PGP SIGNATURE-----

--CdrF4e02JqNVZeln--
