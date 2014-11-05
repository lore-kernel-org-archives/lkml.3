Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaKETkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 14:40:23 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58230 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbaKETkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 14:40:21 -0500
Date: Wed, 5 Nov 2014 13:40:47 -0600
From: Felipe Balbi <balbi@ti.com>
To: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Todd Poynor <toddpoynor@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Arve =?utf-8?B?SGrvv71ubmV277+9Zw==?= <arve@android.com>,
        Benoit Goby <benoit@android.com>
Subject: Re: [RFC v5] usb: phy: Hold wakeupsource when USB is enumerated in
 peripheral mode
Message-ID: <20141105194047.GQ6548@saruman>
Reply-To: <balbi@ti.com>
References: <1415095254-24683-1-git-send-email-kiran.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YzdYn+D7cUqe+VA3"
Content-Disposition: inline
In-Reply-To: <1415095254-24683-1-git-send-email-kiran.kumar@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--YzdYn+D7cUqe+VA3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 04, 2014 at 03:30:54PM +0530, Kiran Kumar Raparthy wrote:
> From: Todd Poynor <toddpoynor@google.com>
>=20
> usb: phy: Hold wakeupsource when USB is enumerated in peripheral mode
>=20
> Some systems require a mechanism to prevent system to enter into suspend
> state when USB is connected and enumerated in peripheral mode.
>=20
> This patch provides an interface to hold a wakeupsource to prevent suspen=
d.
> PHY drivers can use this interface when USB is connected and enumerated in
> peripheral mode.
>=20
> A timed wakeupsource is temporarily held on USB disconnect events, to all=
ow
> the rest of the system to react to the USB disconnection (dropping host
> sessions, updating charger status, etc.) prior to re-allowing suspend.
>=20
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Arve Hj=F8nnev=E5g <arve@android.com>
> Cc: Benoit Goby <benoit@android.com>
> Signed-off-by: Todd Poynor <toddpoynor@google.com>
> [kiran: Added context to commit message, squished build fixes
> from Benoit Goby and Arve Hj=F8nnev=E5g, changed wakelocks usage
> to wakeupsource, merged Todd's refactoring logic and simplified
> the structures and code and addressed community feedback]
> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>

you still didn't get this right. I asked that you introduce
usb_phy_set_event() as a separate patch, then make PHY drivers use it
and only on a third patch should you hold a wakeupsource.

--=20
balbi

--YzdYn+D7cUqe+VA3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWn0/AAoJEIaOsuA1yqRElTUP/RuBM+6iWOgBHnqoXKiMkjNA
GH5SMA+4SSWPzEPr7Ii7yfI4cRLP6xrqp4YP8n4fnt2VCeGiAAusvPiHE+1T0t6W
qJdqpcCZkKB84F0rgnsEJf5Cr2JvmIyAScH+mTUHYhkeYbXErOhfHSIoo47LObY7
sJOXx3VeSY6eB1KH8vxiX3TkZqtnMEJ5p4Fl8e3SPISq7/pSZ9DozlumJDn9jXDF
vOr5fvQ73XXCe9MLPzysPmQ0vyC9swlLjj+GIMZZxtaKX0ESQ5flW99kX6Ko+s7j
AZsqrZ+4Q33MrntwtD97jLHgmhipM13PMW/Kz909G5XdGvf8SiJH6RHHRisnhMQG
gCEDsD58MCss8oasd8U5uk0VgixkwHCh4b3Qm1Z5vOV8B+tvImvWoS5RuFWEbMqi
6Rlh1CPowWXZ/SxSOGunwlxPn8o6ua9gc1oGqflSPtc1dwvmOJdfVvUIGnld5toE
2+aSjs8iP/CymJ01YKOKiOCrXXE7FecP51Wov0SfwKemaoIXoIFxfxuDiTxMNwX0
65jiYktHYzk3wi88sBid29+tR+5mZ3F8o+BxbAZaaPSToOQD4d66mmoRVSCjB6it
Tw1iA44ph0Icni6ij59mS0l5QO5PaEZwIt1kqexvVq3bhjyXlTnD49rf+LTSmiCV
iP1uOgcfgP+sCjcm0GKa
=GueP
-----END PGP SIGNATURE-----

--YzdYn+D7cUqe+VA3--
