Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab3BVJYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 04:24:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61373 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab3BVJYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 04:24:40 -0500
Date: Fri, 22 Feb 2013 10:24:29 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Dong Aisheng <b29396@freescale.com>
Cc: Alexander Shiyan <shc_work@mail.ru>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v4] mfd: syscon: Add non-DT support
Message-ID: <20130222092428.GA27937@avionic-0098.mockup.avionic-design.de>
References: <1361460542-2872-1-git-send-email-shc_work@mail.ru>
 <20130222065548.GA3252@b29396-Latitude-E6410>
 <1361516478.223331042@f282.mail.ru>
 <20130222071311.GB3252@b29396-Latitude-E6410>
 <20130222072718.GA24114@avionic-0098.mockup.avionic-design.de>
 <20130222082954.GD3252@b29396-Latitude-E6410>
 <20130222085212.GA27653@avionic-0098.mockup.avionic-design.de>
 <20130222092055.GF3252@b29396-Latitude-E6410>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20130222092055.GF3252@b29396-Latitude-E6410>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:r25526x6NjUqOOayMAEZe1MFQ5efMvYKhqIOnS5Bgjw
 M/1ODtovNxQlIkaS4SPWgJ86O3dCyIiNLxLQrj27Wzg9rj8JLw
 wbL3rpqgOWUlkaHuJQYP/UXlh5iTCc6MHaUzUHmMZxQyZ1qjvZ
 rbEcN8RCYhAMYmzrII0q7CTi9oW/et5p05E/K3QeihhDp9pLz6
 BvjWkD7RWfB9cmH9cYNZfXDj3EfuGnqw2kRR43yHhvZoDVEFRq
 anbiI09QPLnZEO4Tte1lHSfxyBMzJh4nQGdwuaRwz0efRL6yGi
 06fYiviWjunpFGRbxlXlzYoZzhMNvPSLkU/bXkmpWXVcVG3qEL
 9VeUCQJ69s5poN4kxqdrfNC6h6qj6cq9Rv8DiA2lDR+Iid72UG
 EQK9sb0LXEb6BVICbrPIETskxr+2/M5Bi8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 22, 2013 at 05:20:56PM +0800, Dong Aisheng wrote:
> On Fri, Feb 22, 2013 at 09:52:12AM +0100, Thierry Reding wrote:
> > On Fri, Feb 22, 2013 at 04:29:55PM +0800, Dong Aisheng wrote:
> > > On Fri, Feb 22, 2013 at 08:27:19AM +0100, Thierry Reding wrote:
> > > ...
> > > > > > > Otherwise, i'm also ok with this patch.
> > > > > > > Acked-by: Dong Aisheng <dong.aisheng@linaro.org>
> > > > > > >=20
> > > > > > > BTW, i did not see Samuel's tree having this new API.
> > > > > > > So, who will pick this patch?
> > > > > >=20
> > > > > > I have same question.
> > > > >=20
> > > > > I CCed Thierry and Greg who may know it.
> > > >=20
> > > > Yes, devm_ioremap_resource() never returns NULL. You always need to
> > > > check the returned pointer with IS_ERR(). The value that you return
> > > > should be extracted from the pointer with PTR_ERR().
> > >=20
> > > Thanks Thierry.
> > > Since Samuel's mdf tree does not have your patch introducing
> > > the new API of devm_ioremap_resource,
> > > do you know which tree this patch can go through, Greg's driver core =
tree?
> >=20
> > I don't think it matters much at this point because Linus merged the
> > driver core tree yesterday, so anything that gets applied now should
> > automatically have the new API available.
> >=20
> I just tried update to latest linus tree, still did not find this API def=
ined
> in include/linux/io.h.
> Would you mind point it out for me?

Commit 75096579c3ac39ddc2f8b0d9a8924eba31f4d920 introduced it. The
prototype is in include/linux/device.h and the implementation in
lib/devres.c.

Thierry

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRJzlMAAoJEN0jrNd/PrOhZQsP/3Avg+vZklRVrINW3FPnK+hr
ytiXSrQkITpTv5qKYkhvjA4mTB0x+1EVkeVVPW37qMw6ZKC99it8DjFrL/+d4qOu
hG1c+X/rKADX9WqlUqp5DDUYbks3SvDJKo6aqzUrIaJ/X1U3nt1CJEFqDjQPPOMN
Ur0LXinpZmL/PC1AWoRfweZu4pfbpvywmSCXHy1iuKvld0GHQ3uvu6Kb6ie5udI+
xuvigNRmxmdBEo1IrRdnNz2Ly0soCZQGSHepXXBXCj+aiD4ueDIgfEBoJnSBNhf7
UYuTyj4DOsLIILKBTIGwfthXELAD21fq+FFklyDT5cDI3EE9sl+pHDM0VZkdBwyp
mCcgEyPVIOh7nhCjaPYb5gljbY0eym9B5D8krp/ZYRzOI/36U/ulJe6qv+nMfcAm
cRgGFGVdSl6UA7rETMxfoQO01gZCUMMnIrIyOvrIymavKYzfupNHtsR8Ci2jTp+N
sVjryKYnxnh/4AG7HwIif2f/Uq+BdlERqCZuUKR0QeW7YRUepvHLavZWmcN0p2UK
RUuzdQLDmgYI6j3zDC8bwhistETa45ppWHJPKkhUr3eWHRyrdZtVtyRD9LZOnLHr
PA68i52Xkg9s+hoTQe314slniK2AutHzcPyrSCwfSElSvFe1ewM4ZVPqraB6EVIR
JUZZHkzYddMxOArwT3gx
=P9RC
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
