Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbaFCPeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:34:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52160 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400AbaFCPeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:34:15 -0400
Date: Tue, 3 Jun 2014 16:32:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Eduardo Valentin <edubezval@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140603153258.GF31751@sirena.org.uk>
References: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
 <20140527192923.GC12304@sirena.org.uk>
 <CAKohpo=AnusM2FGs=JLozSyTc0N7SDXQxe+rPiLEHP6ewxY4ow@mail.gmail.com>
 <20140528173858.GG5099@sirena.org.uk>
 <CAKohpo=T3BG9X0gHfRA-x8B3ou3Y=XHcs=OTYAHikX61iAJ9xw@mail.gmail.com>
 <20140603145347.GE31751@sirena.org.uk>
 <CAKohpokRk+PDokcgRdQc+EfRs6t7Uduk8mJinBfANCs36-5_oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y18yPE/eBgOv3N1p"
Content-Disposition: inline
In-Reply-To: <CAKohpokRk+PDokcgRdQc+EfRs6t7Uduk8mJinBfANCs36-5_oQ@mail.gmail.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulators: Add definition of
 regulator_set_voltage_time() for !CONFIG_REGULATOR
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y18yPE/eBgOv3N1p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 03, 2014 at 08:52:04PM +0530, Viresh Kumar wrote:
> On 3 June 2014 20:23, Mark Brown <broonie@kernel.org> wrote:

> >> - We are checking 'regulator pointer' before calling and don't need to
> >> handle anything there..

> > I'm not sure what you mean by this.

> I meant that sometimes regulator_set_voltage() is only called when pointer
> to regulator is valid.

Could you please be more explicit about what you mean by "valid"?

--Y18yPE/eBgOv3N1p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjeqnAAoJELSic+t+oim9GFoP+wZMvXSd8cWwuN4X7zkDqLs9
3OH2XSttzfRa7Ekhvq2s9rbR+KH28sth5CbytaWBN2JJdPfsR7nWu6bI0ivwvexh
mR6H2SZ06DJE4WC8poCdogDZjZ5d6DbUMbuJoCvWFD6U5Dsd6TQeA+TZyqSugnFj
OhZGBcivT62RWq7yzeyA+RBFJV5GkXfLTgELeQX56irBLaMTqT8sjjkaPl/BEEHs
SwpZ/i5EfDKAYvQJGnVq/qBB34rZLT/ETS/eWRcskAxAIhfdeIPCotqcCQWJY8Ub
p60cDn6gx5bmFuPDSWI2ReV0ip60UroLhDksl80oFWvJdUV3DZEurSu+hLQrDYHk
HAE9/AiH44459Qzveb9GbHgdAZTefFJ8uljbKjU/PObpskBFtG94TYOE6vPymoBT
xVjqXNM5/Qle/yFXW3TrVSeZSBSZCKkRPnSK1ZG8igRPP59Vpzby9k9/OJ4J7vlt
eqVftIZzVbIsFIgVeTvdIg2WvjI1IencUFrfvBTC6sO2uAOLhwFMI4jvAjwRqp8V
xQ/M6iBlHy7l4dALS0mcH6fNPxeg3L+4nqNu4BPWt+LfCBlIIha9maLgJecqB3uq
Ob/BJEWzx15/JtBG08BI1Y0zaxTOBaT8d6eALX7v/7lZ5tcZqfBFlsxcZKs+/QS2
mV4DDLxy7L67vZ3GTn26
=up8l
-----END PGP SIGNATURE-----

--Y18yPE/eBgOv3N1p--
