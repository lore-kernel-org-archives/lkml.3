Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab3HPWrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:47:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36353 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab3HPWrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:47:14 -0400
Date: Fri, 16 Aug 2013 23:46:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130816224654.GV30073@sirena.org.uk>
References: <20130816200009.GU30073@sirena.org.uk>
 <Pine.LNX.4.44L0.1308161625520.1532-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6qFdnjy6dKaiDX/E"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1308161625520.1532-100000@iolanthe.rowland.org>
X-Cookie: There is a fly on your nose.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Non-enumerable devices on USB and other enumerable buses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6qFdnjy6dKaiDX/E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2013 at 04:39:47PM -0400, Alan Stern wrote:
> On Fri, 16 Aug 2013, Mark Brown wrote:

> > The device in this context is a running instance of the driver.

> It's kind of difficult to understand what you're saying.  Obviously the
> literal meaning is not what you had in mind, because a device can't be
> a driver (or even a running instance of a driver).  Maybe you meant
> that the word "device" above should have been the word "driver".

I don't think using device to refer to an instance of the running driver
is that obscure a usage to be honest...

> So you seem to be saying that significant modifications would be needed=
=20
> to get platform information to the driver.  I don't see why.  Lots and=20
> lots of drivers use platform information right now.

> Besides, you need to get the platform information to the driver in any=20
> case, no matter how you decide to solve the chicken-and-egg problem. =20
> It shouldn't be a factor in deciding which solution to use.

It's not that this is hard, it's that I don't see how if you already
have some concept of the device in the kernel data structures (which you
must have in order to be able to provide platform data when it's needed)
anything is gained by not using that when dealing with bootstrapping
issues.

Anyway, I think it's time to try to implement something rather than talk
about it.

--6qFdnjy6dKaiDX/E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSDqvaAAoJELSic+t+oim9HAYP/1C8U3l0mluWUZu3I26nQY1X
hXu9D/4seUH/AUamUFIoxdo+4BiWYSc7ChsVLdzaArKwQrlRyoOdqqlWts6eqHVA
dOY0eoxbiuPQ7nGhlPurm/LCtBWWgvHZ9ry5enZLD69gyHwpL8NhS35LXNGPMed2
bJ2P04w/JZ2NlQOS0Vlzu+VKXug77L3ph8vQxbsZsm4tEWKLj5gjRUjHlnZy1gbt
NUuzJQnii08imdfO/u85DsS2Jhgk3guEuTqlNAoGSqtMc4tnCtXIcNXLsXefPata
+RcsgsDajgCVicP3moHSuMJf40987T4wp9TMzk+kGSyGlAnFIFMqj3bo4jbFoDtF
18+lse7g8+ZjwEthTxfYcyWoyh03zwpLqq+AIWLGrHcjW2vKqG4C4XC8z6uAPSIT
7VyVhboWAOpgzj9OL+st6b5ATRxilb3ugLpLvxcmnfFeP1ksvOEkuUDOXHKWkQ9E
kId08flHisXqMmfByPzDucQYxDZPeEVIBVz+PnWIbudtqO6EfKEQJD0L+WsE9d0+
qLhulUdLt3qY39yMG4OQ0FYEcisJvfpaB7gW2jQnj6YCzIL9I2Te191Sujrp+6QG
If/oo+6ee4QAk7nwvAbBVRrc2na5t4YJk+8kjIwNqQ4+PSwz2kfdOod1W2Z8yqZ4
IzECHx8jBvLowYTfVTCI
=jugJ
-----END PGP SIGNATURE-----

--6qFdnjy6dKaiDX/E--
