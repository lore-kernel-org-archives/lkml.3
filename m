Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab3JWLaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:30:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45544 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752629Ab3JWLaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:30:06 -0400
Date: Wed, 23 Oct 2013 12:28:09 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Fan Rong <cinifr@gmail.com>
Cc: coosty@163.com, daniel.lezcano@linaro.org, linux@arm.linux.org.uk,
        tglx@linutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.com,
        rob.herring@calxeda.com, linux-sunxi@googlegroups.com
Subject: Re: [Add SMP support for Allwinner A20: PATCH V5 3/3] Add arch count
 timer node in dts for Allwinner A20(sunxi 7i).
Message-ID: <20131023112809.GX3041@lukather>
References: <1382027827-10080-1-git-send-email-cinifr@gmail.com>
 <1382027827-10080-4-git-send-email-cinifr@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BjOm3tsK/2NdfZj2"
Content-Disposition: inline
In-Reply-To: <1382027827-10080-4-git-send-email-cinifr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BjOm3tsK/2NdfZj2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 18, 2013 at 12:37:07AM +0800, Fan Rong wrote:
> Linux kernel usually use virtual arch timer for smp cpu tick. But the
> arch timer register VCTOFF normally is very different between the two
> cpus in A20 afer hardware reset, so SMP Cpus will see different time
> tick. It will cause kernel crash currently. You have two choices to
> fix it: 1 Simpley use physical arch timer, 2 Set VCTOFF to same value
> for each cpu in bootloader. The first choice will cause some other
> problem for kernel, especially for KVM, guest OS want to use virtual
> arch timer. So the second choice is perfect. So if you want to use
> arch timer for smp cpu tick, you must ensure you bootload have set
> same VCTOFF for all cpus.
>=20

Is your patchset working without that last patch?

I'm not really wanting to apply it right now.

It relies on a bootloader behaviour that is not implemented by any
bootloader we have openly available right now. I will apply it after
it's been merged in at least u-boot-sunxi.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--BjOm3tsK/2NdfZj2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSZ7LJAAoJEBx+YmzsjxAgUsEP/j9Llb0DVBUwhFTgQ79KjwS1
64huiN/41x0sKn9UDwgUOzC02U/jOqmzE6Drh/bq4VYKSvNZUOb/Dpl08Em4emIn
EBLAgLr03DwwA+qj0nCfTfTopV7C+UHhen21j01T7fhhglsJMKtgaDPYdkWCfuky
v/7fJbfMM1nJmNLrlQInFQUtFHA7Hmb7GWf8RejhrDGnkDp2HaYHhCp5nzw36isv
Yc2+ybkXX+MSlwuEwRaYQXSFGMt/E2gHdAlw4HaIrRS+tZBJuVH84YeUpKXWnMTP
W0MgC6dUmSnyMlMkY/3oQPinHLPc2/MStO8TrqBngPGTdhjzNCya+YuVSiS/Iaih
j+4dpLTB+3EVhRp2I9bJl/oW9Fa6GjWoLqnGlPQfWMZbTx7oLaTCW5/eCLxUPlYW
Pes2Y4ZHMdZjEP+VGeDb7qJkepqsTkqfuY8PeUhhYYDveCxxqkbMLgVcNi3zn4zX
TXzJW4Z6GosWy+34iwl649T7XLf3BJcyFxrZy/1ttfQXgR2MjRVnYj0jJgLCangN
0I1ihX2DBA1ukIgOqiJVvNfm2f7B7C/raOJJzoxkdWVD0t4SfOggw2vmtNSj2ME6
l6dAWw3KmK+Pf8g5mOhuQulYzmd/MGxEu2Vi605RXvj8RVB43SmW+Q5kx2AeMv8t
p9PUvMnCdR7+goChnR3V
=Mo3R
-----END PGP SIGNATURE-----

--BjOm3tsK/2NdfZj2--
