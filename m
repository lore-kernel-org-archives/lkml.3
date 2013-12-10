Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab3LJPB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:01:59 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:64678 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3LJPB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:01:56 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stern@rowland.harvard.edu
Subject: Re: [PATCH v7 2/5] usb: gadget: add quirk_ep_out_aligned_size field to struct usb_gadget
In-Reply-To: <52A68BF7.2080901@linux.intel.com>
Organization: http://mina86.com/
References: <1386633338-10919-1-git-send-email-david.a.cohen@linux.intel.com> <1386633338-10919-3-git-send-email-david.a.cohen@linux.intel.com> <xa1t7gbdfn8c.fsf@mina86.com> <52A68BF7.2080901@linux.intel.com>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131210:balbi@ti.com::qyubDPKoJEC5UlIF:000000WtT
X-Hashcash: 1:20:131210:gregkh@linuxfoundation.org::ZT+4mLVQaeikavLZ:000000000000000000000000000000000000Mvo
X-Hashcash: 1:20:131210:stern@rowland.harvard.edu::AvQc9rqMEWyQYngf:0000000000000000000000000000000000000ouX
X-Hashcash: 1:20:131210:linux-kernel@vger.kernel.org::VEO6ds3yduezYd/u:0000000000000000000000000000000002CcW
X-Hashcash: 1:20:131210:david.a.cohen@linux.intel.com::21irrgDMMQ2djNdF:0000000000000000000000000000000059f1
X-Hashcash: 1:20:131210:linux-usb@vger.kernel.org::33buDecqCaJ+zvVt:000000000000000000000000000000000000BR2i
Date: Tue, 10 Dec 2013 16:01:45 +0100
Message-ID: <xa1ta9g8iwbq.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10 2013, David Cohen wrote:
> I've got no idea how returns became reguens :)

The keys are like right next to each other <http://bash.org/?5300>. ;)

> But maybe Felipe can fix it when applying?

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

iQIcBAEBAgAGBQJSpyzZAAoJECBgQBJQdR/0zXEP+wfcKSOb1+Dv4oSP3vMlT/CM
NHbxADn6FSjAJe36LfUfTAAVD46YCVePl3qsnHBA7Spc8UcCIZp3wLRB40pMNI41
IkxPMmRji+5ZnZa2bz8+OHgnxipZUsS57/WACU2gFPnPTKjzGWOvumvimx3BUMOt
m6r3yAueTCUsS5D5CWMgPSRrdoXO0wkXPf3TJLsJC7cSoYlqmYdJv9S0fF8FbwnZ
mXuouDcQE3gOhoTQ1gAnQs1vL5tJKo+wP/RS4yc0aTy20Ua1ywyQ8fVPoqIgfxrp
ihE2fcVGh2+HJSMjS1I4tF7aNQLavN0GYNVzdSppw6moLqdNj9Ki/di3Oc8KpEhn
eA3/g8DRdovYLSruQQck2FLL2wqNuieyCGSd1/3Evq7jvw6DMf/aXUhLVJbmb8yz
pMQ+CxkiUHM7S9RDA2hVtCWDA61xNLkryRON3OeFvyLTIrEa1LtWHYkl4xUeexNV
0nrAS6m2kU2VF5wyCLQgjt0a3yWNX3gZBK/PjhEoKjqs388816uiIEztpDtV8KIk
Wc039XHXM6hqldphCZnzdRejNm6zl8YDAqK+C9BSLUqrwU0YqIWWntukoVnl//t3
h4wodn7yZIbtsYv1uT8Jpa0u77qZhGFDPbpWOBUnzzpZ0bM0i7I5Qfg22e2YZTeT
yAPMGzlKu2aXj3K111Wk
=/zAU
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
