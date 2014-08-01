Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaHAIkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:40:19 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:40858 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbaHAIkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:40:12 -0400
Date: Fri, 1 Aug 2014 10:40:04 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 8/8] clk: tegra: Add EMC clock driver
Message-ID: <20140801084003.GA21724@ulmo>
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
 <1405088313-20048-9-git-send-email-mperttunen@nvidia.com>
 <53CE97F2.80300@wwwdotorg.org>
 <53D75FA7.1030300@nvidia.com>
 <20140729201939.4627.79710@quantum>
 <53D81CD4.5010307@wwwdotorg.org>
 <20140730093456.GA29590@ulmo>
 <20140731190659.4463.92139@quantum>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <20140731190659.4463.92139@quantum>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2014 at 12:06:59PM -0700, Mike Turquette wrote:
> Quoting Thierry Reding (2014-07-30 02:34:57)
[...]
> > Not merging this feature upstream won't stop anybody from implementing
> > it as a hack in Android/product kernels either. If it's useful then
> > somebody will implement it in whatever downstream kernel they use. And
> > if it's useful to more than one vendor then we'll end up with a copy of
> > the implementation (and derivations on top) in each vendor's tree.
>=20
> Thierry,
>=20
> That argument is not sufficient to merit merging code. There is all
> kinds of wacky downstream code that gets duplicated by various hardware
> vendors, Linux distributions, the Cyanogenmod community, etc. Should we
> merge any piece of downstream code just because more than one person
> wants to use it?

Of course not. And that wasn't my point. My point was that if people
want to implement hacks as shortcuts and avoid the work involved in
doing things properly, then they will find ways to do so irrespective
of whether code can be merged upstream or not.

But we're talking about a debugfs interface here. It was designed to be
used to make life easier for *developers* and provide a way to make it
easier to debug problems. I've certainly been in a situation a couple of
times where I wished this kind of knob had been available to avoid
rebuilding the kernel and rebooting just to tune some clock frequency to
see if it would make things work.

> > debugfs requires superuser privileges anyway, in which case you could
> > equally well write userspace software that directly bangs on the clock
> > controller registers.
>=20
> Sure. There are lots of technical reasons why this isn't such a bad idea
> (e.g. you need admin privileges, we shouldn't ship devices with debugfs
> turned on, etc). But by merging it we tell people, "hey, this is an OK
> thing to do", which it is not.

I disagree. What we'd be telling people is: "Here's a bunch of knobs
that you can use to play around with clock frequencies for *debugging*
purposes." Using debugfs is never an OK thing to do for production
software. But I don't think you'll prevent people from doing stupid
things by limiting what a debug interface can do. The only thing you'll
achieve is to make it more difficult for people who want to use it the
right way.

Thierry

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT21JjAAoJEN0jrNd/PrOh4D4P/34h95JtSC1TN6pVliHH5gXd
elVsZHgq7cDdo4x5/kUyrEeIIEuV2W2xg6pZcHLiuuuCtgJr3xlNaW6SI1drXe8B
n9SHwCsHZ7oEsKSrdLAffUT0fFjT29Z5I8XEQMv1GLGxQOzN4/TCpJi8OlBMDHcv
quC9arTVz1XkN8wfkNmnWpVvwdHSkIQmKvcqosQWk2xSV9WvrIWKZ0wXy//v4JNy
75hTvZL6icM+A86TnsoKITolv1JDbwp7FcBoWX2rA9svzhfK4PcMkblKdGMPfWU1
KfeDVuEXV4s6IuowuxdrgeF7udAFCjDs3H23PUfA20MZPwLrPqH9XQ/RZoopZDqR
YYqwt+xpyjzeOAjsAPqj8/UzFcgz4w3spYPQ6BNS0C7YeFwqkjvkj1GSaGg4KSxc
rAIoxP3vso+gF9K4l2qBDRXDhMUU+m2M7XpypH//ezvwez+RsV1rvb//vrkSMIpl
Pyz1+63PBTRKVczAZPlzhA/FwNRSMTRPcNlvzb3s3aGu6MPzOpzNW6HxjXRvnW/I
2KBiK/lv8BZuUC9kGCY4wojMBPRDyKUR6WpRyxSvK2uRt73cn35gBsky+TxyizAX
Veqj0O9oI/WyCgVGAuj4vI5HTNpsmxnTsdtgUGUH/vdjsqAw7S0N/N0d/fM7Bak/
Ey11ihxIz2mDMYXJcPev
=gghn
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
