Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab3IWUj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:39:56 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:40647 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3IWUjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:39:53 -0400
Date: Mon, 23 Sep 2013 22:38:29 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 9/9] gpio: tegra: Use module_platform_driver()
Message-ID: <20130923203829.GB5216@ulmo>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
 <1379320326-13241-10-git-send-email-treding@nvidia.com>
 <CACRpkdbLGThUTteqmEcfda7Tvc08ZFWwe=WpKMyxALQe=LZLVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <CACRpkdbLGThUTteqmEcfda7Tvc08ZFWwe=WpKMyxALQe=LZLVA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 23, 2013 at 09:25:53PM +0200, Linus Walleij wrote:
> On Mon, Sep 16, 2013 at 10:32 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > With the driver core now resolving interrupt references at probe time,
> > it is no longer necessary to force explicit probe ordering using
> > initcalls.
> >
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> > Note that there are potentially many more drivers that can be switched
> > to the generic module_*_driver() interfaces now that interrupts can be
> > resolved later and deferred probe should be able to handle all the
> > ordering issues.
>=20
> Let me see if I get this right: so this would be all GPIO/pinctrl
> drivers which are probed exclusively from the device tree
> so anything that depends explicitly on CONFIG_OF would
> be a candidate?

It includes all interrupt providers that are probed from the device
tree. I'm not sure exactly what the situation is regarding DT vs non-DT,
but if my memory serves me well, with non-DT setups interrupts need to
be hard-coded in the board support code. Therefore I don't think the
usefulness is limited to drivers that are exclusively probed from device
tree, but rather any interrupt providing driver that can be probed from
device tree.

> I think we have a bit of a problem that some drivers depend
> only on a certain arch or compiles directly for a certain arch
> without any specific Kconfig option so that this may be a
> bit hard to spot, so we should keep an eye out for this
> once this probing scheme is in place.

Yes, it certainly needs to be decided on a case by case basis. There
might be other factors that prevent a driver from being a proper module
driver.

Thierry

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQKbFAAoJEN0jrNd/PrOh/ioQAK8raKpecttc0qM+PcG6fkPu
PfpsoiXLPjWW9kOLtpqJtCy79bTDvVWgg1wnzIDH3BO3ROLu200341jR8abQviRR
6JpsvjJL8eQjzB15wdokfPhnADCc+SA60J+0+JqkGpQs81ABjoKTQNonKzXbDDPi
rt9U6wpdi2t5OaeJNPmM0CzDhz2w64fKhNEcejX55cj2+gUeIUOuaj7s6XoBd8Mz
jJRcw0YsrbQPrsrfu360Mc1lXxwOmhrLJA3zW46asX3YLIbPY/gjY8R1ck1Ny5uF
0Fz99kq7xLIR15RZnaCfEM6Flyg5gYAxvvPbIwt2qgPdoBaKNGeia20G4GlIvhmN
FSOskDIC+oyGIU/RW7kl8wIJKYFsh5v7KM80pTuL3+bGryQiiHtc5MD5HVvBf66r
oE+6Vpl/XzsI9cRPiT3kFuSSHduRHdkx3mhtYl9Zw97D3C0AfP94PvEr+4gf/yDO
vbo/ddSiaFN/TEo5xd7jHYUS//2KRQOea9xdbbJKdrcZy/il45/hKoA3dGuCLPen
s3HGCmLeuLRKa3k5nse0w6gbpfHf+8JBhAsQq8/C7GTaSM77cxeGD90QKEfefNXu
+OpMYzhwqdXzv0594WctxpP+NCfrl22R4S6jyou5HB6P2mmKF+50YYOEhSZUVN/R
vW6WJUku915Uri6nQp/s
=R3jY
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
