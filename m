Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab3IZMIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:08:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51141 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756810Ab3IZMIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:08:41 -0400
Message-ID: <524423B6.4070609@ti.com>
Date: Thu, 26 Sep 2013 15:08:22 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>
CC: Mike Dunn <mikedunn@newsguy.com>, Richard Purdie <rpurdie@rpsys.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, <linux-pwm@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Robert Jarzmik <robert.jarzmik@free.fr>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v2] pwm-backlight: allow for non-increasing brightness
 levels
References: <1379869196-19377-1-git-send-email-mikedunn@newsguy.com> <5244065A.8010408@ti.com> <20130926115108.GA1680@ulmo>
In-Reply-To: <20130926115108.GA1680@ulmo>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="iV7PU31v0Ga2vTXmWE2MHTIkHDRcCpi1d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iV7PU31v0Ga2vTXmWE2MHTIkHDRcCpi1d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 26/09/13 14:51, Thierry Reding wrote:
> On Thu, Sep 26, 2013 at 01:03:06PM +0300, Tomi Valkeinen wrote:
> [...]
>> But if you and Thierry think this version is good, I'll take it.
>=20
> That sounds like you want to take it through the fbdev tree. Jingoo is
> listed (along with Richard, but he hasn't been responsive to email for
> years) as maintainer for the backlight subsystem. Furthermore back at

Ah, so they are. I just thought it falls under fbdev, as it's under
drivers/video/ =3D).

I don't have any particular "want" to take it through fbdev tree. But I
can take it.

> the time when I began working on the PWM subsystem, the backlight sub-
> system was pretty much orphaned, and pwm-backlight was by far the
> biggest user of the PWM subsystem. I adopted the driver at the time
> because it needed to be updated for PWM subsystem changes.
>=20
> What's the plan going forward? Given the coupling between the PWM
> subsystem and the pwm-backlight driver it might be useful to keep
> maintaining it as part of the PWM subsystem. On the other hand, there's=

> some coupling between the driver and the backlight subsystem too.

And backlight is coupled with fbdev... Which is something I don't like.

> I have a couple of patches queued up for 3.13 that rework parts of the
> driver, so it'd be good to know how you guys want to handle this.

Well. I'm happy if somebody wants to maintain the backlight side. In
fact, I'd be happy if somebody would start restructuring it totally,
it's rather messy. The link with fbdev should be removed, and some
backlight drivers are actually panel drivers. However, perhaps Common
Display Framework is required until it can be fully cleaned.

So... For the time being, I'm fine with merging pwm-backlight via any
tree that works best. I'm presuming here that backlight framework and
fbdev (for the parts that are relevant for backlight) are not really
being changed, so there shouldn't be conflicts.

 Tomi



--iV7PU31v0Ga2vTXmWE2MHTIkHDRcCpi1d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSRCO2AAoJEPo9qoy8lh71F3oP/24fwYFPvO1wkWx5aM34isYm
UBbb9YQ9dIKCClvnI9m3CoNGu0DbCE+E2lYX07K3aJje3DYtAYIo9moUhRbweZfp
bye7Qrpl48foz1sqTDO3mDyB+etc6j+0mAJmFxCFa8RYOmhISNVywqXJ7mOCleN6
QRrIsXk9SI2l/ePmuAuvinzgZBWIQHkPxPEDD4afxvQVDf8nYNfjeMaPgztDgDK+
MMN55m7YYkJkHsbXRSinZWzLw0VceoPxwKkJGNaZy8D9/w/fb3FOWeqR962Dhrqv
Q4kAR0Vmn1neOHL6B3LZ1CSWf+hlv5hBvsLI7hXBdNq1JT2Z8r84tEgkR2j94w8k
5HN39lyRxZ5vU+sM7/EFW9TJSZ4IeYDqNqQyVejFRQrkrWSpzyN8fJd/u8R0EGEv
TelYAVtr83VzVPALsb9DvFJ9WYqgUI46Zczqk0do1mw1aFBCh3+BDCut3vJLP4Tx
lqHccOKp0ldSk2JaTFc6wRqJBKQs7ekCwrZEieKrfR/uzj7G69pMxF1sAj441fVo
l90HmoF4g9lX4NpHkCk9e8OPhqAZc3VHXOdAxEO4fPnMzM3r9rlzmJAx9wCOq1ES
D36aVy3BzWjD4KdlsHJlqy7Lv98KJjgW50p9YZGkjIt8OW1fRkQRpeu/ha5c1oV8
cvlZuk+Yqwz6SdtJVfJP
=seaJ
-----END PGP SIGNATURE-----

--iV7PU31v0Ga2vTXmWE2MHTIkHDRcCpi1d--
