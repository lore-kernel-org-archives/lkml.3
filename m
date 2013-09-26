Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab3IZNBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:01:36 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:40485 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab3IZNBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:01:33 -0400
Date: Thu, 26 Sep 2013 14:59:54 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Mike Dunn <mikedunn@newsguy.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v2] pwm-backlight: allow for non-increasing brightness
 levels
Message-ID: <20130926125953.GB2141@ulmo>
References: <1379869196-19377-1-git-send-email-mikedunn@newsguy.com>
 <5244065A.8010408@ti.com>
 <20130926115108.GA1680@ulmo>
 <524423B6.4070609@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <524423B6.4070609@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 26, 2013 at 03:08:22PM +0300, Tomi Valkeinen wrote:
> On 26/09/13 14:51, Thierry Reding wrote:
> > On Thu, Sep 26, 2013 at 01:03:06PM +0300, Tomi Valkeinen wrote:
> > [...]
> >> But if you and Thierry think this version is good, I'll take it.
> >=20
> > That sounds like you want to take it through the fbdev tree. Jingoo is
> > listed (along with Richard, but he hasn't been responsive to email for
> > years) as maintainer for the backlight subsystem. Furthermore back at
>=20
> Ah, so they are. I just thought it falls under fbdev, as it's under
> drivers/video/ =3D).
>=20
> I don't have any particular "want" to take it through fbdev tree. But I
> can take it.
>=20
> > the time when I began working on the PWM subsystem, the backlight sub-
> > system was pretty much orphaned, and pwm-backlight was by far the
> > biggest user of the PWM subsystem. I adopted the driver at the time
> > because it needed to be updated for PWM subsystem changes.
> >=20
> > What's the plan going forward? Given the coupling between the PWM
> > subsystem and the pwm-backlight driver it might be useful to keep
> > maintaining it as part of the PWM subsystem. On the other hand, there's
> > some coupling between the driver and the backlight subsystem too.
>=20
> And backlight is coupled with fbdev... Which is something I don't like.
>=20
> > I have a couple of patches queued up for 3.13 that rework parts of the
> > driver, so it'd be good to know how you guys want to handle this.
>=20
> Well. I'm happy if somebody wants to maintain the backlight side. In
> fact, I'd be happy if somebody would start restructuring it totally,
> it's rather messy. The link with fbdev should be removed, and some
> backlight drivers are actually panel drivers. However, perhaps Common
> Display Framework is required until it can be fully cleaned.
>=20
> So... For the time being, I'm fine with merging pwm-backlight via any
> tree that works best. I'm presuming here that backlight framework and
> fbdev (for the parts that are relevant for backlight) are not really
> being changed, so there shouldn't be conflicts.

In that case I'll just take it through the PWM tree as I've done for the
past year. I have some other changes planned for the PWM framework for
the near future that'll create dependencies between the PWM tree and the
pwm-backlight driver, so keeping them in one tree will make it easier to
merge them.

Longer term it probably makes sense, as you say, for someone to take
over the backlight subsystem completely and give it the love it could
really use. If Jingoo can do that, it'd be great. Perhaps it'd be a good
idea to remove Richard as maintainer since he's obviously no longer
responding to emails. Keeping him Cc'ed on all patches is just
pointless.

Thierry

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSRC/JAAoJEN0jrNd/PrOh7FIQAIN4Aw8XIjswMbmLF+kK0el2
cZSuoyGBvZotfodaUi3/kdMS0nPWIYIsnVgHwqYCTFO37D8eHGwB6T67TwBHnolE
hDCAWimitmyJa355uU2vodHQ05533Y1TC7NsqCQHIIY5r9889YuYrYKfYol7vB3O
/5FrzcGaxwrXs0yxtsZa3uT6M6nll9U8eirhNZRwsbqpEDdIKmA0MTtsEMbXClBh
wv7H81FGwgRwlynwfyrKlW4SEJCC41pDWf+N8ZfNyXIAZO8mmDPDs/NTHiEszmR/
MEG3r8Pq4UCS1RNM231i3ZLdJebswe0B1nLaOdu/n9e4A3+RddlAepPM5ODtV87h
b7l23eH1cdj+UAipdW/PParjVzjMvSlWZA0eS1BvOowWTpq0E4hI1igX/Q3zodLD
lP3ie8xAUeXl2k/KBwPhB9GW1twWt/aEoO/a3g9EX+gCrSvYULi2G55l+3O7QjVO
Ml6uphCG2mN1GTBoI5PC4FgCUnFl0moB9i6rdgLaLE593GhtnApGC9kQtXzL0VSt
HwM+C50bkGobp5HFektJn6ApsmQZI8mP0oNVWK6j2zTFhpSlG+BPD4RvJa7A2tgK
Yalp8OmErU5481iMe3JjEvBG7IRgZCqU4lb+1gt8M2CUGhamaXesz1FXrYwk4yhD
jYQCRf3wOEzLj6njhiAk
=3trL
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
