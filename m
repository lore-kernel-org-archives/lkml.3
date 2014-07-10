Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaGJNnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:43:35 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:63517 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbaGJNnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:43:33 -0400
Date: Thu, 10 Jul 2014 15:43:30 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/16] i2c: i2c-tegra: Drop class based scanning to
 improve bootup time
Message-ID: <20140710134329.GB14961@ulmo>
References: <1404992799-3705-1-git-send-email-wsa@the-dreams.de>
 <1404992799-3705-16-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline
In-Reply-To: <1404992799-3705-16-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 10, 2014 at 01:46:35PM +0200, Wolfram Sang wrote:
> This driver has been flagged to drop class based instantiation. The remov=
al
> improves boot-up time and is unneeded for embedded controllers. Users hav=
e been
> warned to switch for some time now, so we can actually do the removal. Ke=
ep the
> DEPRECATED flag, so the core can inform users that the behaviour finally
> changed now. After another transition period, this flag can go, too.
>=20
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>  drivers/i2c/busses/i2c-tegra.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

It looks as though this currently doesn't do anything on !X86 anyway and
I'll trust Mikko's testing, so:

Acked-by: Thierry Reding <treding@nvidia.com>

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTvpiBAAoJEN0jrNd/PrOhDb8P/2DQMSn8ZMMHOcqMf1h8sv7S
Ymo+qUhJoood5RKsgXWriAJBs9A5wOS+Kl9+JN/FDMFCs8gGCEb9/ur+QYY5ySps
TR1+RO6rE19IdXzZZpVaL58H5H/oTC9BcadRni3Rd3ZAivOeE4ikW+4VIAX4CpPi
WA0DVIWLhiCqUQEg8CyrGmBaZGbHf2BDuNuvz19HOjrL/R0DeBEnXwk91rjLHpi8
IqeqZQLoAwnF1+RAnbflZeSXFUVtKxb8tf45la2E3scXOax+nAcaJvBKERYj4wWh
3QYTwKKNqHrVFbCUMmi/CTbtFPoYI2yOZkEo1ygISt1Grc5g+c9EsKTVo02+dVWF
uuIQtnY7ao4UROHg2rhUDt0Z5iYvvk6NWkdL3iBDelT+rZn75RrJVC0xOZ6a9et4
K3DiOUaqckBqCCcmuCOMnloZJ7N7H60jukTNP1Uw2oaEoqs/IQU7KEM55818qJsH
0lEhxVW/2aB5PvxEICl3Lwyeqmu2hgQ5Ef8nLXthsqUxamHyPJXEkOI0bm7MgfaQ
OHfrGs+QHPLWaeWz4nzbdwEliwQpjXAuVyCc6HLqomB9saGmC8VvXFSkx1bYqCL5
ufDvmvagQ8+legtUhHwmg3IJLFkXvmEOWM7yslRDSOtnH7fcrSzmNmwkwYg0i7WB
qae1z5Va6b7NyeL/a/Gh
=jyu0
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
