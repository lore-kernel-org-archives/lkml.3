Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab3KGXqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 18:46:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab3KGXqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 18:46:23 -0500
Date: Fri, 8 Nov 2013 10:46:04 +1100
From: NeilBrown <neilb@suse.de>
To: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/2] LEDS: tca6502: add device-tree support for GPIO
 configuration.
Message-ID: <20131108104604.54366464@notabene.brown>
In-Reply-To: <CAK5ve-LzYLr0xuvNA3MX=pECPPfAkDFqExPpmQt8GF+9jf5uHg@mail.gmail.com>
References: <20131101134120.13a44225@notabene.brown>
	<CAK5ve-LzYLr0xuvNA3MX=pECPPfAkDFqExPpmQt8GF+9jf5uHg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7srOLHoSFsyr8_R9uFOIQ_V"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7srOLHoSFsyr8_R9uFOIQ_V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Nov 2013 15:39:00 -0800 Bryan Wu <cooloney@gmail.com> wrote:

> On Thu, Oct 31, 2013 at 7:41 PM, NeilBrown <neilb@suse.de> wrote:
> >
>=20
> [PATCH 2/2] LEDS: tca6502: add device-tree support for GPIO configuration.
>=20
> I think it should be tca6507, right? Typo?

Obviously I'm still dreaming of the Apple IIe.  Yes, a typo.

>=20
> For other parts of this patch, I'm OK for them.
>=20
> And just a quick scan of the leds-tca6507, I found bunch of typos in
> the comments:
>=20
> * An led-tca6507 device must be provided with platform data.  This data
>  * lists for each output: the name, default trigger, and whether the sign=
al
>  * is being used as a GPiO rather than an led.  'struct led_plaform_data'
>=20
> Can we unify to use GPIO and gpio?
>=20
>  * is used for this.  If 'name' is NULL, the output isn't used.  If 'flag=
s'
>  * is TCA6507_MAKE_CPIO, the output is a GPO.
>=20
> Here should be TCA6507_MAKE_GPIO and GPIO instead of GPO
>=20
>  * The "struct led_platform_data" can be embedded in a
>  * "struct tca6507_platform_data" which adds a 'gpio_base' for the GPiOs,
>  * and a 'setup' callback which is called once the GPiOs are available.
>=20
> Don't use GPiO, please.
>=20
> Could you please review the code again and submit a cleanup patch to
> fix those typos?

Yes, I'll send a patch shortly.

Thanks,
NeilBrown



--Sig_/7srOLHoSFsyr8_R9uFOIQ_V
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnwmPDnsnt1WYoG5AQIWLg/+P0wdrBjWoPIgvwKtvSdWBDoldOIdDVH5
9X60txSnJIEN2N0CIhcu5VWQ+cH9XtZmY0Ab2RnMjUmXfHg5I1gIPYoGXjtJaJYD
j8CeD/OIG8qumMJAZtAtbUOsV8UI6rp77acVhAEiOEPcRJS7BG2GG40gxw4S7d68
BOgX9LWyQDWdneyj32j2SzUYhyepMh2zdQLYsGfCLollbfZfyoHP/F3KdcIJZNu4
kci3jKsfBfzGJCMXVtbARsyC7e4+OAUpq+f/sG7ZwqeN2j7pyp8EnWpV56AUQYBN
ijQLfqk36YjVIFpBX/fplCG0z8oDq2WJcUYorQrmuM8LNOq9ozUV9FJbN4g21EeG
lH4jR9OYVrqnBcfZ3jvo6HFfMi31ozTgcLEUGGy4M6n8K2uEbVqax9zJxnbcNcme
/WzT4BGJ4oDpEyPPXjUnSRbvO3uXC7wciZg/ZFx2BCVEZhXUeSqT/yLyAuqF+fgo
KS+VGQm1mdnd4jWtL4Aq/6VeAg6EY1U7OxzkRTPJXKUn3c/J2DbbbjjA1LW8Bsad
uAPNYiIwrVS7pHZKMqDzobvfDEnCCzGNQOZnki57xfQvwpO8iDMMKNCve68eMZc6
m5Lzx0y5IYQCC+s/A9bTMPrreiJceHKYtm7KJTCVpExZBDYDZAlecW8I6/Z7Q+Lt
il68/XeSKI0=
=EV88
-----END PGP SIGNATURE-----

--Sig_/7srOLHoSFsyr8_R9uFOIQ_V--
