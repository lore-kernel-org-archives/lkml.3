Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab3I3KPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:15:18 -0400
Received: from sauhun.de ([89.238.76.85]:35000 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863Ab3I3KPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:15:14 -0400
Date: Mon, 30 Sep 2013 12:15:00 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Libo Chen <libo.chen@huawei.com>, linux-i2c@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 1/4] driver core: introduce helper macro initcall_driver()
Message-ID: <20130930101500.GA3222@katana>
References: <1380518035-5319-1-git-send-email-hanjun.guo@linaro.org>
 <1380518035-5319-2-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <1380518035-5319-2-git-send-email-hanjun.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2013 at 01:13:52PM +0800, Hanjun Guo wrote:
> For some devices especially on platform/I2C/SPI bus, they want to
> be initialized earlier than other devices, so the driver use initcall
> such as subsys_initcall to make this device initialize earlier.

And this is something we want to get rid of in favor of deferred
probing.

>=20
> But for those drivers, lots of them just do nothing special in
> xxx_initcall/exit, so introduce a helper macro initcall_driver() to
> eliminate lots of boilerplate just like module_driver() did.
>=20
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>

So, NACK because using some *_initcall in drivers should not be
encouraged.

Thanks,

   Wolfram


--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSSU8kAAoJEBQN5MwUoCm22lYP/1yp8oyuansz0qy9vW/oUeHa
dBr2w1JH66nXyVx46p3kfnMaYfLvw7WxmiMQLm5lse1uObAKH+xXC9dZCG2VCdLu
MTokQFYi0ueejnAr61FrDX5hUGx6hfkbSN5XO5ftHeOnNiSuCNwBRf5gekx4wABC
kR9+DyB41dxy7dRI046aNYY4dXsMwyAlU0lsAOeVJniNWFqftmpx91ETmvqMIUsn
/V7D0qRV+EwIllnc4t4p5CXxvW2saQVEcT3wag8LCM/ylk3QcOPODMtKtaUa9Hms
LB9VHEIAxsezzgbTP//xrkcksHX9KvkSG/4H0D4FmhjgvzrbGFSRLltGkdkieiv/
Uh9/mmv+3CDjsQwiyjMqtapugZWfyfQ667cwUTbLepSdvb22WfvRVrBGBi9JnAgQ
368WlzedAF7+x12zoT/ZRF9F2LDIu05JaYOZpL+hoQpX7zZ7U7nrM3u14tXPnf5V
M1it6tKbymxI9+OZEV7zjJpKPXkagVSn9I4z9bJidtwj415aQ3Q30d8CS6OAnMvv
6a6+YOztmhNj2JX9IWq2K6n6kgdp9n46aOrbBcaFIGGYg+1vj1YAivJ6uHWjEo70
0Vo0m4EzAPNblDAmp12ZAhG0BdKbZrudA0IyBhq8UvInJ9Jgp6zLJNn87tgAZq6Y
XDXXVodMXz+STDPOl3xb
=FBar
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
