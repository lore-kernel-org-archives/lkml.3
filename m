Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbaKUPLB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:11:01 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46347 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbaKUPLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:11:00 -0500
Date: Fri, 21 Nov 2014 09:11:05 -0600
From: Felipe Balbi <balbi@ti.com>
To: Kiran Raparthy <kiran.kumar@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <balbi@ti.com>, <john.stultz@linaro.org>,
        <sumit.semwal@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Arve =?utf-8?B?SGrvv71ubmV277+9Zw==?= <arve@android.com>,
        Benoit Goby <benoit@android.com>, Todd Poynor <toddpoynor@google.com>
Subject: Re: [PATCH v1 2/3] usb: phy: Handle per-PHY event for connect and
 disconnect events
Message-ID: <20141121151105.GC7508@saruman>
Reply-To: <balbi@ti.com>
References: <cover.1416547297.git.kiran.kumar@linaro.org>
 <7a23b5f0af4463aea85384b6a67678b9c41b9d2d.1416547297.git.kiran.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5G06lTa6Jq83wMTw"
Content-Disposition: inline
In-Reply-To: <7a23b5f0af4463aea85384b6a67678b9c41b9d2d.1416547297.git.kiran.kumar@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5G06lTa6Jq83wMTw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2014 at 11:31:21AM +0530, Kiran Raparthy wrote:
> usb: phy: Handle per-PHY event for connnect and disconnect events
>=20
> When usb is connected and enumerated in device mode or when usb is
> disconnected,call usb_phy_set_event from phy drivers to handle per-PHY ev=
ent.
>=20
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Arve Hj=EF=BF=BDnnev=EF=BF=BDg <arve@android.com>
> Cc: Benoit Goby <benoit@android.com>
> [Original patch in Android from Todd]
> Cc: Todd Poynor <toddpoynor@google.com>
> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>

this patch doesn't apply, please rebase entire series on my testing/next.

--=20
balbi

--5G06lTa6Jq83wMTw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUb1YJAAoJEIaOsuA1yqREFgMP/AjG9Xkkt81qmT/Yc8jFG6QD
C0fzYCKGDehCaSjzbwjg2Iz46qgcrvylZPdAJ7328u1v2h2ysPswnzziauoC5rkt
7MSqSPL1hOMZgXsoB2Pf0/DBblhdRTLP8wCLUa/xzWbgzZqzcjpZwCO3mwD/id47
8kNg+1WNjJl9VyuhGLWgEkucQ0J2HGhg8AfnHxOjE/BJyiHS+uCbLclwYFbasDtN
xd4YV6Vq9off2sy5BCRIP6j0Gdy3GAib6WLeFEOhIDzarrglxvmLZtP2a6DSCG3v
GhIXEpPaAPXk6Y0aX+1v4oleBFCi8ToIh3ZOx/iv++BSOWoHfG5F0a0BV4ynUber
yj+nIHEtdSKyR8dWD7cfrQJC04WwmFtBLODX5aE3WlgAarpw4S1eSctji7dis3RP
EMpmV1uUGU98Oy45GVVwJva3GivtM9yaQfmsLu9ndc8YNW3leoiyxcfBaLryNpMo
9wcdabsEaEd4du3mZ0NuxXKxSVPg4Nu6HU3xkQiccbtjcUE2psV3WactdICXnMJx
waGMPrDNcE3peTWUa1nEoKtjnNUnJ4DOFRrR9YDnEAJlWmFIjlh4MilkQG/4nJtS
aiV9U5AkS804oI1GaSOzFQH9PNg0zEaZWrXyBXbr8w4E+UT5hVZ1Tv4WKp4pFYke
kfYiT1Hr+F2E7WxByJvZ
=/gQ/
-----END PGP SIGNATURE-----

--5G06lTa6Jq83wMTw--
