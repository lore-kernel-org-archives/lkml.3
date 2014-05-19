Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaESWTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:19:18 -0400
Received: from sauhun.de ([89.238.76.85]:60836 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbaESWTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:19:15 -0400
Date: Tue, 20 May 2014 00:19:02 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>, swarren@nvidia.com,
        abrestic@chromium.org, dgreid@chromium.org, olof@lixom.net,
        sjg@chromium.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, Vincent Palatin <vpalatin@chromium.org>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sameo@linux.intel.com, jdelvare@suse.de,
        shane.huang@amd.com, maxime.ripard@free-electrons.com,
        laurent.pinchart+renesas@ideasonboard.com,
        u.kleine-koenig@pengutronix.de, bjorn.andersson@sonymobile.com,
        kevin.strasser@linux.intel.com, linux@prisktech.co.nz, andrew@lunn.ch,
        andriy.shevchenko@linux.intel.com, schwidefsky@de.ibm.com,
        matt.porter@linaro.org, ch.naveen@samsung.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 6/7] i2c: ChromeOS EC tunnel driver
Message-ID: <20140519221902.GA2871@katana>
References: <1398879850-9111-1-git-send-email-dianders@chromium.org>
 <1398879850-9111-7-git-send-email-dianders@chromium.org>
 <20140519105055.GA2612@katana>
 <20140519172258.GD20435@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20140519172258.GD20435@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2014 at 06:22:58PM +0100, Lee Jones wrote:
> > Code looks good, so
> >=20
> > Reviewed-by: Wolfram Sang <wsa@the-dreams.de>
> >=20
> > I don't mind how it gets upstream. I can take it, but you can also keep
> > it in this series.
>=20
> Let's keep the series together.  Are you happy with me just merging it
> through MFD, or would you like a pull-request, so you can take it in
> too?

Just merge it...


--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTeoNWAAoJEBQN5MwUoCm20pIP/3uHi/PK3vNRfj6srP5o+bH7
GI1HE0FPB4RaNmmeTb+hpp4rlynNvbpcnGUdBlopjgmXDkHDpbfM7GSuc12bEyqX
uuBxpIQmX5X/aYysgZf2K8oHvTz4HmthINu+8gRDrztBwV0wuviorpb7aFjmJK+w
aniFjSH7hykvqMi/+abYUEobn0elMrKzkx7+GrmpeXLUXyHNKxhpzP3Xp7ZhqlQt
ldKMXiqQTLn6tzyZAVUPWiA0kHbqbbWjwpXse2S2ARK/JxMzIkV9UfR552EFwTWN
g6UPT5h0uA7vlSVdV5vLpkSF+Zu9Q+fHT/CaleXHgJs7PKfB2Lizuu8MzCTytBRR
wKb6fzMjrq2nkq8GFt0oxTxzpX/Xtcs9k5wcQm57n7gKjbz8f+It+NvmuEHOiHMV
HvNfRHA9LW14sPutJjZXOVl1nQVZsJPQWoPkbc82fhg8RuhaAYxJw3+PBRR9N4VJ
aZbHJtI3uE/hb6dyq7rhQyg72LoDyTy3H9bfz9SyJsv+AlCc1FK4l3tHltB9IRoM
jBnNFLJ0VEW+0at36Ztv51UOLf3nOhdM8pfeA7ehet+FNVs7Bq55z7jsxVTO8udO
deYp4gMLc8Ggghj47BzvWVfR2Oy7cn1/lhlfMzFD3J9VR39Zxla1FsLIbTbb1cMF
1qiT7wKNJjcL1c3k0GGB
=56Po
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
