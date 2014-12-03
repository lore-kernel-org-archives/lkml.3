Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaLCLxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:53:48 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39520 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbaLCLxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:53:45 -0500
Message-ID: <547EF9C2.60106@ti.com>
Date: Wed, 3 Dec 2014 13:53:38 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Quentin Lambert <lambert.quentin@gmail.com>,
        Thomas Winischhofer <thomas@winischhofer.net>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Converting int usage to bool
References: <20141127104133.GA5051@wrath>
In-Reply-To: <20141127104133.GA5051@wrath>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="Il5MoGSHs36JbqMLbsEESBmaj3750TQse"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Il5MoGSHs36JbqMLbsEESBmaj3750TQse
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 27/11/14 12:41, Quentin Lambert wrote:
> The following semantic patch was used to find
> functions and variables declared as int but
> used as boolean. The patch resulted in a
> significant number of false positive that I
> have ignored.
>=20
> I am not hyper confident about the modification
> I made to the functions. Some of them seem to
> have quite significant side effects, which is not
> necesserarily intended from a boolean function.
> In particular both *_rwtest functions write data.
> Moreover sisfb_find_host_bridge name may suggest
> more than a boolean return.

I don't think I'm going to apply based on the above. I do like bools
where a boolean value is used, but changing it like this to a single
fbdev driver.. Well, I don't really see much benefit in this patch, and
there's a possibility for regressions.

 Tomi



--Il5MoGSHs36JbqMLbsEESBmaj3750TQse
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUfvnDAAoJEPo9qoy8lh71Wl8P/0jBeENpJLhDbG4G572QarhN
AziXFgxaULZWi+2atxW5lcI3D3Rca9i6Rb/NDWNrRQtomuha5Tm3mSS1DA5LIb+u
XpAj788GvsMShIFqEvon6zhdfzOguBDPk6gi6IH0Tj6QteCkAiv+45scTMNu/sZk
/iACZlIcjcBpG4e+lG9Kq0NKN4hadEmnTbuWKT0qalGQnqDYs+z63UND30b6hgYT
ssvhWttXZ2RauP/zKO5U+b1GsIqJehYwZMwjs2tiiccg3truYwknSsSXOiqN8fcB
IhOt8Aexpvf3a9UEUROKwyyFbH0mb6/f0klkIn/nUeMG5RIaqrSdS+BLtodoyBUj
3fRV+hucLW3LoGOnjdl6wTZQ8ezi7jgYNparwcZgb3SSATr87AqTh6mqRM46A3PT
/udlDMJsgcs65IL0gixPiZN+t/uInNvCRlKpgygOLr+CkIBp8LXdzJjCIDotkB2X
RbBPOdcAuhUZrfr5mdkpr7wDL0Z0UN96/xn4wODmvoc0MkDm9SqSiczaUjJIUIOV
3nxfv/iYzh4+0WlzsilbLTnLMoazcKXKsk7ETT78AuXjydHJRTXDOXv/NqV+2kHW
MLn8sR6ztT06lJ3cwdumtpYaiq6OU9eBd8J3RpOLk0TB1Zi4VFdQqRzXF5YnkSv0
QQ/Gi6/yXmWIHNSApcla
=eMHP
-----END PGP SIGNATURE-----

--Il5MoGSHs36JbqMLbsEESBmaj3750TQse--
