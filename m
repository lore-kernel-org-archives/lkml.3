Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab3A1RUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:20:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62027 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab3A1RUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:20:42 -0500
Date: Mon, 28 Jan 2013 18:20:26 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH 07/33] dma: Convert to devm_ioremap_resource()
Message-ID: <20130128172026.GA16202@avionic-0098.mockup.avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-8-git-send-email-thierry.reding@avionic-design.de>
 <20130128160020.GY26562@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <20130128160020.GY26562@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:tjDouOVPFcL1uQpgmlkpoRk2L1UApxOyvaxu6WtMNky
 F96c3waBPfGFVV4QsL0zA5aJOjX06GZFM8mycGJyeVODq1Wu1g
 Oi/PEcgbu6AKF9G7id2yHixAC3qlpJ2h6ZP9GBTexN0EjJs7Es
 ++WywBmf1D2TkRT8WFomOcnCMZ4mNt35f3tMVEqY9OkqnavjA7
 zdaThRMMG5XCOwZf1j3Uj0FQn+2+PoSAsHS1wIZgxWg+rVPLcW
 f2GHlosGo6mjqBDKL2ovmLKlgEQHISDl/A1MxaXgjx9t1Q003I
 QqbRY420QON/jZS9Xm6eoQbOg6H2RyyIxJzXR+ojVhLClRVr3E
 B3uX3MCrBB5Y6v+GneZeKjdQC+24XaIxvKyfpW2mhHmfqvKurI
 2EXnhzfeuFG9BOJfDvuk339UHspYGjbMaDiqcrwocIiSpfLDDQ
 Re58y
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 08:00:20AM -0800, Vinod Koul wrote:
> On Mon, Jan 21, 2013 at 11:09:00AM +0100, Thierry Reding wrote:
> > Convert all uses of devm_request_and_ioremap() to the newly introduced
> > devm_ioremap_resource() which provides more consistent error handling.
> >=20
> > devm_ioremap_resource() provides its own error messages so all explicit
> > error messages can be removed from the failure code paths.
> Where is this symbol, applying this results in build failures for me?

I was introduced in the first patch of this series, which I failed to
send to everyone concerned. Greg agreed to take this series through the
driver-core tree given the dependency on the first patch. AFAICT he's
already applied this patch to the driver-core-next branch.

Thierry

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRBrNaAAoJEN0jrNd/PrOhzEMP/3D+cw8bpNWbAV9vq5XkGFdE
EmrysXAc7KvyiHWqni8QDfyJCUryglgM1Dy6dxxaiJovAYmqjD/arhfDbS194dDe
sDi2sgLZqi3yDZEayl8dL8NaI5YQJ18xLwTQGlmPJy76jxQA5eu3aOwnv1N7XTbU
3SHbITVCymyodp6LXolJ+gf/BK+kTM81AKti6g8rxK093Eyw/G1uR3u67KKZHL7U
5fSXptl7KKcZUJsNkIdcPVJ69d/0hDiyDoYQzfdzW9clYZbjs4oMRETk+8ymJZbj
2WfecOWIvxft7x8hBqANl4HWweFUDGzQWXRLvbQ2uFDNwyYrYeRvSDnMwTEae3KV
9LDM2wYRRUAlWRU9xDVfsivYDOsL81sIERHICaYfuxiiwAEmWLkmvEYH0E7fMHrP
ZU5uqwPk/ytIWIbVLqkLi3u54nK3rYTYUsSQQ/AsDOzslrMrxfnF03LZEPXwlgrE
rVhI7+8H0S501UhbIogl3Bl2V46Q5cCO4YMRezkkTncXEW8E/4vAtOhhhEOblqJR
/RFGAWvgNNOdxRTcGMOxhii2l8EKB1KswgtW1XLkAMgkmC6eLf1eaT7bodh3uzRQ
kqgEtbbRC5buF1zzMiMY4Kx3Od4Hf7Chtre5MJZGplrBCkkvbjR7ss+lHAhjb71e
wDZLZ6iqZHUQgMkyTCoj
=57Cr
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
