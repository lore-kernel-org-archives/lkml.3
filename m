Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbaBENBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 08:01:52 -0500
Received: from kolab.o2s.ch ([77.109.136.180]:34271 "EHLO kolab.o2s.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaBENBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 08:01:49 -0500
From: David =?ISO-8859-1?Q?Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Baatz <gmbnomis@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/6] ARM: sunxi: Add driver for SD/MMC hosts found on allwinner sunxi SOCs
Date: Wed, 05 Feb 2014 14:01:33 +0100
Message-ID: <1676482.sbjAhaSLaV@dizzy-6.o2s.ch>
Organization: O2S GmbH
User-Agent: KMail/4.11.4 (Linux/3.11.6-4-desktop; KDE/4.11.4; x86_64; ; )
In-Reply-To: <20140205103949.GC3192@lukather>
References: <20140204191648.29809.14611.stgit@dizzy-6.o2s.ch> <20140205103949.GC3192@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2087342.yc2NcSH50b"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2087342.yc2NcSH50b
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Maxime
> I have four comments here:
>   - Read Documentation/SubmittingPatches, especially Section 5 and 12
>     (hints, you forgot the clock maintainers for your clock patches
>     and you didn't put any signed-off-by tags)
Oops. I added signed-offs now
>   - You ignored pretty much all the comments that were made during the
>     review of the first version. Go through
Uh? I just fixed the commits and squashed them together for easier handling.
I'm even using mmc_of_parse now...
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-December/219339.
> html and address the comments that were made.
>   - Each of your patches should compile. Fix the order of your
>     patches.
Done.
>   - Submit a v3, with the changes you made. Otherwise we have no way
>     of knowing what have been fixed and what didn't
Too many patches would be bloaty.
That's why I've squashed them into small and corrected patches.

> Looking forward for the next iteration!
Good :-)
You can have a look at the recent status here:
http://git.o2s.ch/?p=linux-next.git;a=shortlog;h=refs/heads/20140205

cheers
David
--nextPart2087342.yc2NcSH50b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlLyNi0ACgkQAeZw77btGjr6zwCglDPMGsllkJPtErxxWEzepqeu
rpoAn3iqBc/AViM5Rnu45QE72zw4y7tc
=eD5M
-----END PGP SIGNATURE-----

--nextPart2087342.yc2NcSH50b--

