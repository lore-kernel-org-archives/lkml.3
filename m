Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab3IOL3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 07:29:06 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:46807 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184Ab3IOL3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 07:29:04 -0400
Date: Sun, 15 Sep 2013 13:27:56 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Milo Kim <milo.kim@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 4/4] Documentation: add LP3943 DT bindings and document
Message-ID: <20130915112755.GB9765@ulmo>
References: <1378949700-6384-1-git-send-email-milo.kim@ti.com>
 <20130912152455.GN11227@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZoaI/ZTpAVc4A5k6"
Content-Disposition: inline
In-Reply-To: <20130912152455.GN11227@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZoaI/ZTpAVc4A5k6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2013 at 04:24:55PM +0100, Lee Jones wrote:
> On Thu, 12 Sep 2013, Milo Kim wrote:
[...]
> > diff --git a/Documentation/lp3943.txt b/Documentation/lp3943.txt
> > new file mode 100644
> > index 0000000..576ebd0
> > --- /dev/null
> > +++ b/Documentation/lp3943.txt
[...]
> If this stuff is really important (and most of it really isn't), then
> put it either in the commit log or in the driver.

I can only speak for myself, but the initial driver commit message is
about the last place I look for this kind of information. I'd expect it
to be either somewhere in Documentation/ or in one of the source files.
In this case I'd probably look at the MFD core driver source file. More
likely, even, I'd just go google "LP3943" and grab a public datasheet
=66rom TI where all of this can hopefully be found.

Thierry

--ZoaI/ZTpAVc4A5k6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSNZm7AAoJEN0jrNd/PrOhLdQP/RahXyucPoSbeWP0AOpQdyeA
nwZ9SA3eTylBK8N2RKDGAWErFQAG+NutyPZLx902wNpnJyuY6NjQvsS+yTxsf7zl
PNH2sa9TBRbJDvna05ijoUeAYilkfcTWxh6Bo2+UvJaSnxYAITRiXm1n+egO2/fd
HoKi9/CiG22xIKJrpIFf6Nlwp3t1F5T7tUhNWSrgR8DXRSmU9s8XLTC5kOBYekaI
Yy9+30jmcgnxGZDkkW1sDGFPe/FeiMUaY3q5um5ah5PjKpYU+vhQY15HN7K67o5I
Fi38fM4XFNvqgwhM65ivjaPWeaZ26Gd81JpBBx382UBZZNph35i/i26cxXqkTTOn
dBJyNH5dD4R8yAc+ninzpWVpjCkWYdmCMelVOjLIWZHEQJ4Y1pcX5YX+cFMIiZOY
3h+35DF2DYD8Y+uJeug0+lNwmNqRx4RBYGrWol1d8hi4CPM1Jn7iEWxl4aO+HwJK
hOzFVHK083MG1NPlDQJCtVlaDrSJFrpqP0kOnvjEFulxXlurTXvLjGDSFkVTWS/I
HibS+v3AnhCWakjQEXC2HEPsbklmIMCavLRQNjc3pNPEtEt32N1qTWZEUtG+X5EV
XOFQDbCSfZzLYH37zoB41hr4boiQLsDRAqigDBWW5wT8l9iJMdaFn3ZNe7XKqh0n
yiLPNKbSkZSfb5ewqc2E
=5WER
-----END PGP SIGNATURE-----

--ZoaI/ZTpAVc4A5k6--
