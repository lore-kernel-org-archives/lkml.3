Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaGJMCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:02:14 -0400
Received: from sauhun.de ([89.238.76.85]:57237 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbaGJMCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:02:12 -0400
Date: Thu, 10 Jul 2014 14:02:02 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Emil Goode <emilgoode@gmail.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Leilei Shang <shangll@marvell.com>,
        Peter Korsgaard <peter@korsgaard.com>, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3] i2c: busses: i2c-pxa.c: Fix for possible null pointer
 dereferenc
Message-ID: <20140710120202.GG2728@katana>
References: <1404418756-10550-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1404418756-10550-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140704091000.GA4738@lianli>
 <CAFo99gYU6v_ohZa6rSfHwUhk6Lw1dCtVWOQsLk3tZ_GRyqExbg@mail.gmail.com>
 <20140704172457.GA3404@lianli>
 <CAFo99ga3K7JBLCRTQGLYNGT4aX1N9azfjfosvFzoUViMcdMhmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4eRLI4hEmsdu6Npr"
Content-Disposition: inline
In-Reply-To: <CAFo99ga3K7JBLCRTQGLYNGT4aX1N9azfjfosvFzoUViMcdMhmQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4eRLI4hEmsdu6Npr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Ok then, Wolfram!
>=20
> Keep only:
>=20
> ereqirq:
>      clk_disable_unprepare(i2c->clk);
>=20
> And let everyone else just return?

I haven't looked at the details, but when you simply can return, do it.

> It is rather pointless to add something in a patch, to remove it in the n=
ext.

Yup, just say in the patch description that it fixes this bug.


--4eRLI4hEmsdu6Npr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTvoC5AAoJEBQN5MwUoCm2NaoQAKlG/uqlmQSce25X1XJSikIw
UnjNPXrESPqvMfzpiodZLx5RBc1aWjpx2WbY3kq5ixlVIftPiPdvYZqaLVn0X0lN
7fQZj/CbD2kRrdvxg+EdnLy5X9WNAISYr7V2HFwWCe7NuHj6+zLOyTAJnYjOapEC
CJDNeV5WzK6Pvej7xgw3Fes95AgbsSdQOY5asRppxlXp14s+nG1zgM5LI5bxRXjs
CXuKZVtTHtJMe+4rDrULwn/nhdFl4pjlOwV17HKnRmYQA364A6ARo9BXl8XrxmUE
OW7pmaZemOZyiEyJIs83YVB+orP5jYBvYTyM+cGDxzroGi2tt8ITjkz5sQ6Z0R9S
NJCDxJa3IxLhl7wP5cOD9q8tw994p6R1nkWLo90CMucGVEm7ybU2mNVMxhlK2T/+
jENg0WihmdXiEhSDzCpgXcjV8SWIvcjhjd1Dy/ylDWRvBVyysaWmGuw5WAqDH1lA
Cxhz9OGbVE2EzZGqrnfPy/3A+WegbDbfSMlmEWhBHFnCsmbgF0XcqongSdNgIan0
bQC0f2zc29taIhfCDhWdydmJgbj9vpU9HXT3prw06Ux2YtiY18VQgydaOZOlgZ2D
KnpIH6RVTNAaYBQoLbqVhBzSd9IJqSxk7Pg5UlEot/McZySysVg915Yczbh/AywW
Q2C/GbmYihw+rNlksa0C
=3mrD
-----END PGP SIGNATURE-----

--4eRLI4hEmsdu6Npr--
