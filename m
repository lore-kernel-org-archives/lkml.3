Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab3BVIwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:52:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51157 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab3BVIwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 03:52:21 -0500
Date: Fri, 22 Feb 2013 09:52:12 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Dong Aisheng <b29396@freescale.com>
Cc: Alexander Shiyan <shc_work@mail.ru>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v4] mfd: syscon: Add non-DT support
Message-ID: <20130222085212.GA27653@avionic-0098.mockup.avionic-design.de>
References: <1361460542-2872-1-git-send-email-shc_work@mail.ru>
 <20130222065548.GA3252@b29396-Latitude-E6410>
 <1361516478.223331042@f282.mail.ru>
 <20130222071311.GB3252@b29396-Latitude-E6410>
 <20130222072718.GA24114@avionic-0098.mockup.avionic-design.de>
 <20130222082954.GD3252@b29396-Latitude-E6410>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <20130222082954.GD3252@b29396-Latitude-E6410>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:9UpL0oNEzz79ExzvRBkBOXSrIhoeQ5o3FVzJOOYw5Mp
 xA+6p0xa/SMS1jrfNCqu3cn4fAyupHV8EEe3u2aj0zCpEUr8tC
 PvM5PxW9JKRSa7bhW/sR59DJ5VnqLMRqqLCi5Mt2uP/okRa2gw
 sfbC5OO/PTwlYktCVh9/SMfiISQFqW4ggaahVLI1PszGdl7SYV
 1hdb0Uqok08BW2ZzUJY4gaj2x1MprKHQ1/ocArqiYJCuef4bIC
 rCUXSLXZYmjUHbWdIcAM7tKpWqc9lC1nWd4W7ALDFIhrPL2+Ly
 By6xlxiBvnebeU8hcobUsB1JmZRLF+EPU/8nU3hTlYYEjsoM5E
 Q74mLNthHDa228/WEwSg5x5bK6zghQyPFGRiZi2OvBbDfkF5S8
 FGKxvcq50Im0yM3dc7IwYSMzVeVIb1gOL2q/8yBauQT7Awsr7d
 dckNt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 22, 2013 at 04:29:55PM +0800, Dong Aisheng wrote:
> On Fri, Feb 22, 2013 at 08:27:19AM +0100, Thierry Reding wrote:
> ...
> > > > > Otherwise, i'm also ok with this patch.
> > > > > Acked-by: Dong Aisheng <dong.aisheng@linaro.org>
> > > > >=20
> > > > > BTW, i did not see Samuel's tree having this new API.
> > > > > So, who will pick this patch?
> > > >=20
> > > > I have same question.
> > >=20
> > > I CCed Thierry and Greg who may know it.
> >=20
> > Yes, devm_ioremap_resource() never returns NULL. You always need to
> > check the returned pointer with IS_ERR(). The value that you return
> > should be extracted from the pointer with PTR_ERR().
>=20
> Thanks Thierry.
> Since Samuel's mdf tree does not have your patch introducing
> the new API of devm_ioremap_resource,
> do you know which tree this patch can go through, Greg's driver core tree?

I don't think it matters much at this point because Linus merged the
driver core tree yesterday, so anything that gets applied now should
automatically have the new API available.

Thierry

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRJzG8AAoJEN0jrNd/PrOhLi8P/3PY/mBlFOX0sxLJ7Danv96b
4WZPqubje/xgJhGmiv++uaKOQWY8K4JsOBd5fJWr827Ez+VOeVrneplBio4JdgEp
jxLHa6mXNchRHg+sqec0lhTFleUuXo8fREXSJZlscmvbpGdjtyS+xv6LfbiQN/su
Y2dfd4B5c18khbkhXBWUaa+guHKglP7JHGXUrRQgl/g0fiqJFXsWVIsbIi2xoL85
nHD8UNrSWiDCM/oNwlaiMz+dS0OENZ2/2BhdHcWokH7M8nFH+NG5T46d/9hC7OJo
UUG3OqtQexnU97VOq1/GIqCUc28ZnkA0lBxPNUfSKB0HA2VoqseJAEQUFZmrtZw1
Isas+uKOqbUPHku6POy9LiQA7FsG0zWVCsFMKv6GNxucKIVlWIE7Exmcs10ktK4h
So23moJqk91atwBlRayE/dsECC81w0vHbIqABjKaXwE9JENAwSNvkNF4sQ2gZcEE
F9a6VvVhpYLn3NHS5v0bOR+CwBquhcRbzr2SdOn9HoPE+63aZJz0rO+0gduq3nRD
ibnUxfYmjKIz6TgUhl760dmKuVGqe8sPif65p/jw7eJYqjVJSn4gjeypp3n5blGS
5NYWW/6pHKGW7HYkIpC4ynblRBD+jaq1vC+vpVfKyH9ZtLKYMbn9PJdDTUkwpSKS
B0GVSA+NJDat32CezLYp
=6iEM
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
