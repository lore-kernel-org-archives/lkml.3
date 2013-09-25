Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab3IYOAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:00:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43187 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755270Ab3IYOAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:00:05 -0400
Date: Wed, 25 Sep 2013 08:59:43 -0500
From: Felipe Balbi <balbi@ti.com>
To: Luca Coelho <luca@coelho.fi>
CC: <balbi@ti.com>, <ben@decadent.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, Pavel Machek <pavel@denx.de>
Subject: Re: [PATCH] ti-connectivity: add wl1251 firmware and license
Message-ID: <20130925135943.GI10746@radagast>
Reply-To: <balbi@ti.com>
References: <1380033894-5007-1-git-send-email-balbi@ti.com>
 <1380107096.4503.8.camel@porter.coelho.fi>
 <1380107278.4503.9.camel@porter.coelho.fi>
 <20130925132359.GE10746@radagast>
 <1380116535.4503.19.camel@porter.coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e5GLnnZ8mDMEwH4V"
Content-Disposition: inline
In-Reply-To: <1380116535.4503.19.camel@porter.coelho.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e5GLnnZ8mDMEwH4V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2013 at 04:42:15PM +0300, Luca Coelho wrote:
> On Wed, 2013-09-25 at 08:23 -0500, Felipe Balbi wrote:
> > On Wed, Sep 25, 2013 at 02:07:58PM +0300, Luca Coelho wrote:
> > > On Wed, 2013-09-25 at 14:04 +0300, Luca Coelho wrote:
> > > > When sending big binary blobs, it's generally better to send pull
> > > > requests instead of patches.  If you add the -p option when calling=
 git
> > > > pull-request, the text will include all the readable parts but will=
 omit
> > > > the binary stuff.
> > > >=20
> > > > Thank you very much for following up on this!
> > >=20
> > > Ah, and I forgot to say that you should update the WHENCE file
> > > accordingly too.  Check the wl12xx and wl18xx drivers for examples.
> >=20
> > I'll send a pull request, but how about this ? I don't think we can
> > change the license. It seems like the other firmwares are using the
> > older license, I'd argue those should be changed to the new one, but
> > that's another discussion.
>=20
> Cool, in general it looks good!
>=20
> Though it would be nice to know if the same "new" license could be used
> for all the firmwares to avoid almost identical licenses.

well, i'm not a lawyer :-s

> > diff --git a/WHENCE b/WHENCE
> > index e66fea5..4e9e2ed 100644
> > --- a/WHENCE
> > +++ b/WHENCE
> > @@ -1705,6 +1705,19 @@ Licence: Redistributable. See LICENCE.tda7706-fi=
rmware.txt for details.
> > =20
> >  ----------------------------------------------------------------------=
----
> > =20
> > +Driver: wl1251 - Texas Instruments 802.11 WLAN driver for WiLink4 chips
> > +
> > +File: ti-connectivity/wl1251-fw.bin
> > +File: ti-connectivity/wl1251-nvs.bin
>=20
> Don't you have the firmware version number to add here with "Version:"
> tags like the other ones? I think you can easily find the version by
> running strings on the binary and grepping for "Rev" (at least with the
> newer WiLinks, this works).

Done :-) thanks for the tip.

> > +Licence: See LICENCE.wl1251 for details.
> > +
> > +The driver expects to find the firmwares under a ti-connectivity subdi=
rectory.
> > +So if your system looks for firmwares in /lib/firmware, the firmwares =
for
> > +wl12xx chips must be located in /lib/firmware/ti-connectivity/.
>=20
> It's a bit stupid that this was never changed in wl1251, but it still
> expects the driver in the "root" firmwares directory (ie.
> in /lib/firmware/wl1251-fw.bin, not
> in /lib/firmware/ti-connectivity/wl1251-fw.bin).  Maybe now is the right
> time to change the driver appropriately to keep consistency? ;)

alright, will do...

--=20
balbi

--e5GLnnZ8mDMEwH4V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQuxPAAoJEIaOsuA1yqREpfgP/3QSOa2tJfZmvOQJZqy8ymuG
vhiJ96CDqntdnUPQoil15zD0LoCdY4apmWS8g9MLZViO9fzul0y8+fkWp+pLRgCD
8/97HCdyZ8r9nZa1bG0kCXgGn+e0TXwBY1ZBJfywpDQ4fWwjprCZPs5Z8i40hhTW
4CRemi3qBh61VmdUO0+y1ollrZuynAdwKXxIcVX5Sbj734wbgX7zQay/ydz6DrK3
deV+3zCE7WD1/i+mISepIdMimvcAzDlg7LoSGw79hToclT1Ee5j0wj40wKvtUoyR
7gd4JJPZExyPwP3SWM9cPrpaKFAYwRLFen3bow8WS0AIPLRa+Q35ENll730q/P8f
R/znJM8oYW9KdDSrhwQqrMeZFwNm4rwkQprFMx/GfM5460TIxkYemzlSpW649mCT
iwCM3V2KUUrCUVLyi9yYxA2tOozF91g8IY74A+x2wcMaJzs/azeNNlf5MQvd+my3
1NMi0CFRVN2lIfHeTZss9pKhOm+zAYK+zNa6S0mFmfNRDNyiOFRx1pudhkipyZ5F
97qV28d9S1rKM1f/pldodjpGn3z1HRQum2Ld9t9o8QPuUIGPNE5V7BC6FX28/EK/
Ka8fRf4VWDfFm5RnhvWd6qz2obkCbwAIVcJEuZRDOZYDBdTQx2p6b2mYlM9f16UB
mVVRxstIu9Exsspf/z9T
=0td3
-----END PGP SIGNATURE-----

--e5GLnnZ8mDMEwH4V--
