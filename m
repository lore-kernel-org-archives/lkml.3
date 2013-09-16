Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab3IPQYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:24:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60880 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab3IPQYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:24:34 -0400
Date: Mon, 16 Sep 2013 17:24:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wang Shilong <wangshilong1991@gmail.com>
Message-ID: <20130916162428.GE29403@sirena.org.uk>
References: <1379094851-26385-1-git-send-email-linus.walleij@linaro.org>
 <20130916091956.GF3999@lee--X1>
 <20130916104009.GA29403@sirena.org.uk>
 <CACRpkdatiELF3WK9qE_Mgcq3iCgv5w3X22xp1=232JJq9sWggQ@mail.gmail.com>
 <20130916135118.GD29403@sirena.org.uk>
 <20130916152104.GA3909@katana>
 <20130916153414.GN16984@lee--X1>
 <20130916160001.GC3909@katana>
 <20130916160537.GO16984@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LJYYZogMzwQTNNqC"
Content-Disposition: inline
In-Reply-To: <20130916160537.GO16984@lee--X1>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4 v2] mfd: add STw481x driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LJYYZogMzwQTNNqC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 16, 2013 at 05:05:37PM +0100, Lee Jones wrote:
> > > So in the mean time are you happy with this "dummy" approach?

> > No. "dummy" is reserved for a dummy device in case an i2c slave needs
> > more than one address. The proper solution would be if
> > i2c_sysfs_new_device() could recognize the of_device_ids.

> Okay, thanks for clarifying.

Or for now to use something like stw481x (even if it's never expected to
actually make a difference).

--LJYYZogMzwQTNNqC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSNzC5AAoJELSic+t+oim9HRYQAJ16Q1v8fjVDnyNQs480KQN0
HJKAi6qUUQh3JziwFpgAf+YbTsXpbGsky27jwDLvtzjdvFymlvOi2BC1a37MzYSB
SHUp3G+Bp2Op5ljSasDukazIswmSNsc5N0GbyHFWism/XjlAZ/k6SsY9/Eni3QVL
T3yZkytMOU8EUzO2tSMM/Pz5zei9kd3UPI0IoCtr/+SvbacIOsljG4gZI02YTfsR
apa1neZhLA9gi8FObCQmKHFMyQNKiwt/FFn8SHd2BZojp5vqhlwZXlAN1QrcuCMH
CtyGd96/ftXC4OXXsWpr6Sh25rdPQhscpN3xwY69QYYCtbujBbC4TI693dinhqGA
sXDLafzfOmM41fHv1Adv8YuldCK7h77zrHQCvTWPNQz8wWgkzWU0g4lBe7weWUvt
711YrGlCPikbV/kLyGMNlwZLVT8R0WSBgelUPVX8YS3BydQFGpXYKyRa3tKS882z
iMpe/hphW425eN7yyFE+kRfC+27CjG5DwvVL8bYYZPV8MSMKexog6sfgfqu40Yq+
04t+W0woxm7TkAVWW0vDbOvl9NbvycfF3Rc2SzWoerdrHcqhF/0UNqBEeSSKu7zZ
ugLSZKdx8nxoXlInzoUUAEFFSIiPoV54gZpUp3AuUBr1AiINGL5kHkJkdydqELSF
7/fuNmV6dild11cYFr41
=TO9M
-----END PGP SIGNATURE-----

--LJYYZogMzwQTNNqC--
