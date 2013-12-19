Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab3LSX1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:27:09 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41359 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab3LSX1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:27:06 -0500
Date: Thu, 19 Dec 2013 17:26:13 -0600
From: Felipe Balbi <balbi@ti.com>
To: David Brown <davidb@codeaurora.org>
CC: Felipe Balbi <balbi@ti.com>, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        <gregkh@linuxfoundation.org>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 00/15]  usb: phy: msm: Fixes, cleanups and DT support
Message-ID: <20131219232613.GH707@saruman.home>
Reply-To: <balbi@ti.com>
References: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
 <20131126163846.GF24310@saruman.home>
 <20131219230315.GA20875@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZYOWEO2dMm2Af3e3"
Content-Disposition: inline
In-Reply-To: <20131219230315.GA20875@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ZYOWEO2dMm2Af3e3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 19, 2013 at 03:03:15PM -0800, David Brown wrote:
> On Tue, Nov 26, 2013 at 10:38:46AM -0600, Felipe Balbi wrote:
> >Hi,
> >
> >On Tue, Nov 12, 2013 at 04:51:35PM +0200, Ivan T. Ivanov wrote:
> >>From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> >>
> >>Hi,
> >>
> >>Patches have been tested on top of Stephen's clock controller
> >>patches[1] and recent fixes for chipidea msm glue layer driver
> >>posted here[2]. Hardware platform AP8074 DragonBoard. Only gadget
> >>mode utilized for now.
> >>
> >>CV Test Suite engine "Chapter 9 tests" are passing except
> >>"Halt Endpoint Test".
> >>
> >>usbtest driver report following failure:
> >>test 13 --> 32 (Broken pipe) 		ep 81 couldn't set halt, -32
> >>
> >>This will be investigated further.
> >>Patches could be applied cleanly on top of the usb-3.13-rc1.
> >>
> >>Regards,
> >>Ivan
> >>
> >>[1] http://comments.gmane.org/gmane.linux.ports.arm.msm/5375
> >>[2] https://lkml.org/lkml/2013/11/11/310
> >
> >I wonder how will this be taken upstream provided there are
> >interdependencies between arch/ and drivers/ patches.
> >
> >I can Ack patches but I'd really like to avoid merging of topic branches
> >all over the place :-s
>=20
> Ivan's patches are the only ones in this window that touch these board
> files in MSM.  It's probably easiest if I ack them, and you can bring
> the whole series through your tree.

it's getting quite late for me. I still want to leave my stuff soaking
in linux-next for a while. I'll try my best, though, if you ack it ASAP
;-)

cheers

--=20
balbi

--ZYOWEO2dMm2Af3e3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSs4CVAAoJEIaOsuA1yqREVIIP/2mbuStKTgLpARGYtrRbpGg8
myEuVaka/H4QQ2Xk+3UZk+kk4FnTkKf9wKqRVwvhEz/t0A7UPfHNUCVMKqt7WFgV
epwoKPENToxoxNz7d6VweB85ch3/A0u7LXA4NYVYST7EhM2dVGFLWriGdaYQUpWK
0pNEHvf+r8YqpuReTr9919Mu8IN1ObTGaG9kTz48GBse1/GEnuhrwwVU2NTnp/dU
wg208gsvXMi1TZEXrgdr9gkQLVydmC21pxQI0jiOSO7cZ/6etiC/DlCFtT8Gl+iY
UkmImldAC0cZZ36rRPjwjaS+eSAKSMm3COdbpQ2cAFoeOO+VrfJEv4xgj3UH4sBB
csEyx89HcxRbZgLVCr9p0zly0z+7c1xGdls/y3hagndkl2Ie9PueWTVL/8mPXabO
zMomxQKn51tT90NyoGkO26+i7xHkV7uF0/bic5075RqFbjwWB5hkw5Y571ngHPok
q0Lpa+yC7dzlCHpmPskHqU1HGr6+OWPY89CK1/LX4IbZseSTLjxnI0+nWQjckmb2
zYjmBbt+DrUIfrksIRN1T4dkXmdUliHIbgU+gS2lHHcdr3Lc8e/nlIrT+W9CDiYA
HC+6nw34LAZVwsEZzzh6doX39sU7CiTx25D1h/NVyzuD4HAnHNAkGtMlKgW/NcT+
ABVVZ0+0iNmrjOqqmfCA
=Ln38
-----END PGP SIGNATURE-----

--ZYOWEO2dMm2Af3e3--
