Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267Ab3IFKug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 06:50:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35272 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab3IFKuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 06:50:35 -0400
Date: Fri, 6 Sep 2013 11:50:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>, lee.jones@linaro.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Message-ID: <20130906105003.GB29403@sirena.org.uk>
References: <1377104014-21910-1-git-send-email-a.hajda@samsung.com>
 <1377104014-21910-3-git-send-email-a.hajda@samsung.com>
 <3144986.QWu11iEeBj@flatron>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CUfgB8w4ZwR/yMy5"
Content-Disposition: inline
In-Reply-To: <3144986.QWu11iEeBj@flatron>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 2/2] max77693: added device tree support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 23, 2013 at 10:08:39PM +0200, Tomasz Figa wrote:
> On Wednesday 21 of August 2013 18:53:34 Andrzej Hajda wrote:

> > +#ifdef CONFIG_OF
> > +static struct of_device_id max77693_dt_match[] =3D {
> > +	{.compatible =3D "maxim,max77693"},
> > +	{},
> > +};
> > +#endif

> As far as I'm aware of, you don't need explicit OF match table for I2C=20
> devices, because the I2C OF core can use the array of struct i2c_device_i=
d=20
> pointed by .id_table field of struct i2c_driver.

> I'm not sure if a separate OF table isn't preferred, though, so your patc=
h=20
> might be fine.

It's still good practice to explicitly define a binding since that
gives a vendor prefix and there are overlaps out there in chip vendor
namings - for example both Wolfson and Wondermedia use "WMxxxx".

--CUfgB8w4ZwR/yMy5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSKbNYAAoJELSic+t+oim9+CMP/0ZtdSimu7l7dcq7N0QkLYXX
WJJcDV9FVst6QGyIndoveTHm8sRty3DFQoWDAU1PPrLcLGze3ItHokqHZ5j6Ck2j
EQButXFpumOQ4Y765TjoH+4FBgEXyVcLwy8SJ7OSLYzy4sPyMy1qcDgpLwVNPIPx
+Hm5nddDMCDRFkfrYLnUrYqhbjtMl5SYA8jYGaNb8s3IEoRCFXgyvyIdtpQeEfE8
BXXge7+CdFycf+rIMWPJ+K2lPtC0VU4+HkCdT40gSXIbPLMgJGcqNkBn9afYYjVJ
1J++y8hStip1mODe+nhG8G0ssS9AdCyQjatdxoMAy9YTGlFIysb8M5PFVamw/sII
20KEO/wn2w8t+LQpJkBvAV0t5QND9Iofgr5yP9HAsBlj9o3jA3su4spHMx4SWdxR
rQnAZtNB+lRBFljS6sRzfkVmHj/60+UqSf4BXvNd+ihYr0FAEu/q0kb7263mKvFj
qp7/F7gV0eYqrGNQ+rt0lfhsj5AAHPhDDJ28pakTc3NktVhpaG90aZe2INZE7VsD
OktOtLy8YHRWRohPzSne8uhZDEiCRihdYDBUl0MT4jkdsCL5ILKqtBHopJZkbv7D
K6S/r9LfN5RLr3vGKGr0nTemqBzyF6OonidGyI+eOvhgChTnecUP39BbqiB1fjMF
4rnFMJ9/9XYFf2AVBLk1
=TmMa
-----END PGP SIGNATURE-----

--CUfgB8w4ZwR/yMy5--
