Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbaHZLpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:45:45 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:50458 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbaHZLpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:45:43 -0400
Date: Tue, 26 Aug 2014 13:45:39 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Andrew Bresticker <abrestic@chromium.org>, linux-tegra@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Jonas Bonn <jonas@southpole.se>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: Re: [PATCH v2 2/9] mailbox: Add NVIDIA Tegra XUSB mailbox driver
Message-ID: <20140826114537.GA641@ulmo>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
 <5184912.mY2hCPH20k@wuerfel>
 <20140826102011.GA31124@ulmo>
 <14224406.FU8QFA3vsD@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <14224406.FU8QFA3vsD@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2014 at 01:35:34PM +0200, Arnd Bergmann wrote:
> On Tuesday 26 August 2014 12:20:13 Thierry Reding wrote:
> > On Tue, Aug 26, 2014 at 11:54:43AM +0200, Arnd Bergmann wrote: >=20
> > > I'm not sure if it's really worth it. One thing we might do is just
> > > remove all definitions of ioremap_nocache and add a wrapper to
> > > include/linux/io.h, to make it more obvious what is going on.
> >=20
> > Yes, I suppose that would work too. I still think there's an advantage
> > in being explicit and avoid aliases like this. Perhaps a __deprecated
> > annotation would help with that?
>=20
> I fear adding __deprecated would be too controversial, because that
> would add hundreds of new warnings to code that is not actually wrong.

Right. __deprecated is enabled via Kconfig, though, so people could turn
that off if they don't want to see the warnings. I don't mind very much
either way.

Thierry

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/HNhAAoJEN0jrNd/PrOhhM8P/Rr+x6dsQRCcRUKorXb6j3dw
YF2K830WVytEP9/GTNb1ZD77BzFrGhW8Wt+z9dfwip43SYxAxArMytiHkthht8Vz
+TnBgsNlAG53MxVdyxWN/snFN5Apjykk1L47M7+BSOwlwtOIMeIDzhTLU1fYiEsJ
q/WGNqsxF5plvDF7vp4pCPBAbVg/rqXYz0abvyHI/xOFWcK1YPoGH8BX6ZhlhyBT
PUg55X+yUk25qiq+lMxAE0CBYqF+te//pAF/7LzZ1xL8XTYGGQ8A5mFzfoxh+iTn
61dmMFF7qeZ3CdP+xl7OxT5UPQyKuv8+yD5Rnx7guy0Se0qAdale1wRGkyZEyj0C
nlogJFOh7qGi9WeG8wJE9GPP4HYwigdDneWWUScg8SCJTG6bPCCCKisPnhU2luqz
OXEEXOK+l38SpanrO1nZIzc0bz3Qt7e4q0G05+0GbVphXT5YYNOJhl64NDwmofnA
pd9Z3KNilkkggAP4tCnF+yFu6swDuiZwvBoIe1O/d7dvUu0FXzlfldEDQS4mdqP9
/6QNyrsznqRptPZkUWIahvNyP80nffzFqNlR5QebQpZD4+VU/9MDwovx1aAyliUH
ryk1vlnshLgsnyqVT0+5P/MbPtZJgxzvozS0zMIRH729xNVblgyadExyWqdRHGAM
ypl5zk2EgIlkjpD4l+Wy
=xbXr
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
