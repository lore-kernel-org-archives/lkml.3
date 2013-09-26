Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab3IZLwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:52:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47050 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab3IZLwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:52:49 -0400
Date: Thu, 26 Sep 2013 13:51:09 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, Jingoo Han <jg1.han@samsung.com>
Cc: Mike Dunn <mikedunn@newsguy.com>, Richard Purdie <rpurdie@rpsys.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v2] pwm-backlight: allow for non-increasing brightness
 levels
Message-ID: <20130926115108.GA1680@ulmo>
References: <1379869196-19377-1-git-send-email-mikedunn@newsguy.com>
 <5244065A.8010408@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <5244065A.8010408@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 26, 2013 at 01:03:06PM +0300, Tomi Valkeinen wrote:
[...]
> But if you and Thierry think this version is good, I'll take it.

That sounds like you want to take it through the fbdev tree. Jingoo is
listed (along with Richard, but he hasn't been responsive to email for
years) as maintainer for the backlight subsystem. Furthermore back at
the time when I began working on the PWM subsystem, the backlight sub-
system was pretty much orphaned, and pwm-backlight was by far the
biggest user of the PWM subsystem. I adopted the driver at the time
because it needed to be updated for PWM subsystem changes.

What's the plan going forward? Given the coupling between the PWM
subsystem and the pwm-backlight driver it might be useful to keep
maintaining it as part of the PWM subsystem. On the other hand, there's
some coupling between the driver and the backlight subsystem too.

I have a couple of patches queued up for 3.13 that rework parts of the
driver, so it'd be good to know how you guys want to handle this.

Thierry

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSRB+sAAoJEN0jrNd/PrOhYEMP/inBrydrfknTB2Xy9tPS/haw
4OY18uao53syGyLxS6Csc9w4rDgjV2AulGMowMVPrmFgO62ZuHDlu8nSMTz6K1ZK
jp1kBpjIxUhuE0v0dp07UvIjQHrb7TxelmGX+xT7PFZsfflNC97Gitl3EU+M09SS
p/EBuBFhTEm0/kr4bqFyi7LxDG+5IkH9Cov6PoGQDY0VWXkN01wzya/NW6Y+edSi
x6K8ddsZyUI+ZjUEJ42z4LkxhSVOEuQYWzl0niEIYEH//UGP+jf7dMrDqM+k0P8T
L7xE2D4o+RjdzzsG9XJ49lCCgLx8/ipWH0zOidUFF1vv6pvGfiudoka64N6TFj32
62wakXI9RNCLYPf6Eg6lmr3i1+GQW23br62VR3IAI9zDg7yVSQZWJEnqE/aovaxD
BgF8zMgSM8fHkO4R9kHTrypYLtOULMbL4y0gFxSjal1JcK1BsAdS4OfFF2bbtJH0
Ungfsi1YTkeGbpQ+wJv+71k2U+s6wQPg3O/V+vFqt14kPXLhU1hGNAtBpGzpHRY2
adyXVKUhhyFilAgVsGTOq2ZrT7DQPdMDaR/qRmFm+bD+8/5Q8whru7y5tTgDbsgn
HXFajMLSwpCkZpW4givj5VStf6kG3UnQIhTgeRgsL2vs1HoX3FHcGqQXRPbez1vN
b/mU1veSV4IeJqLVJAbc
=ElDE
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
