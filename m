Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab3KLNAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 08:00:08 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:56609 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab3KLNAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 08:00:04 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5.1 4/5] check quirk to pad epout buf size when not aligned to maxpacketsize
In-Reply-To: <52817251.3040509@linux.intel.com>
Organization: http://mina86.com/
References: <1384201011-11114-1-git-send-email-david.a.cohen@linux.intel.com> <1384201011-11114-5-git-send-email-david.a.cohen@linux.intel.com> <xa1ttxfiwkw0.fsf@mina86.com> <52817251.3040509@linux.intel.com>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131112:gregkh@linuxfoundation.org::dJv4XaA5N1dRfL52:000000000000000000000000000000000000B6o
X-Hashcash: 1:20:131112:linux-usb@vger.kernel.org::TvUs7XI8dNncAFrP:0000000000000000000000000000000000000ODN
X-Hashcash: 1:20:131112:balbi@ti.com::N2d5cgzmq28hnezi:000001cMs
X-Hashcash: 1:20:131112:stern@rowland.harvard.edu::2GiuJtZzo7MhlLRc:0000000000000000000000000000000000005r9J
X-Hashcash: 1:20:131112:david.a.cohen@linux.intel.com::Qncgn04XI7jyb0Xe:000000000000000000000000000000004+aR
X-Hashcash: 1:20:131112:linux-kernel@vger.kernel.org::3oyxe47yWP8Ik7wk:0000000000000000000000000000000008GDr
Date: Tue, 12 Nov 2013 13:59:55 +0100
Message-ID: <xa1twqkdlqr8.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12 2013, David Cohen wrote:
> You need to update req->length otherwise it's going to crash DWC3.
> I'd rather to keep your previous version.

That's unfortunate.  Do you want me to resend it or will you just send
a v6 of your whole series?

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--

--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSgiZMAAoJECBgQBJQdR/0uJ8P/3Fqd/YVZd051NQk2VTovKyT
RJ2RSQxHTv1UA7zHrnmJwmV5tfRW1R4Z+3kJb0oJzzKLduyu6wNM3Le8GTuQPRxw
5UGhvYqLLDnK5z86MbCV3MsRC/ugnX3WvtYkT7O/+LtFUFp3AqDKHCnG0eUmo7a4
QgHWsbrGjsTlxcsnY+Q59Jk6ZN6DNskMRmZh+BX5EWRzmH8F7h/75xEdoi8E9DAq
Oxjc6rtKsaEn19XfyFEVCPfgXL+UwO/PQgQGFKVTNn6yFTGjw0hStw6Px1sAdj4j
LlE4qMUqaHWdafLa5r73v6GV97S5khpvNnMisxVUFyQRjB7K3J0RHXDMHl8yTO4i
ErukqisVwGgYuOSh0HbhWY9QQVBggtbbVMcaW7cQ0Idpg4mvqVVvOj3GBg7BL4si
pgErW2jTigjcGQNJ7Yy1wIO2ER2IP7kZo0gEjgUnX3CksJZCAeD+AMvLeFPJx2jr
tCvsZk+dagFTlVOdGnnXTHzCT/KJUg0vIXsB/Sc+CWoJVPMoLKYe+lwiH7U4MCAB
MufY6J2nWZzNBoQ403ICHyv8FLqB1u5APpu+5/FlvaOKVPOlFp81Q3KR6nHv3Zi1
xr0sSXEe+b/RaY1XnzLCECcy85Hk4VJ4S4rcvQeAkXRxx2x1tOYIfVtEJ24fjgNi
8hmYhQFBH59h+HxrHEaV
=qJHw
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
