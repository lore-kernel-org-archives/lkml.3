Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab3I3WL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 18:11:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56124 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756365Ab3I3WL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 18:11:58 -0400
Date: Mon, 30 Sep 2013 18:47:09 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: cinifr <cinifr@gmail.com>
Cc: coosty@163.com, Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH V3: Add Smp support for Allwinner A20. 1/3] Add smp
 support for Allwinner A20(sunxi 7i).
Message-ID: <20130930164709.GA5287@lukather>
References: <1379852488-32147-1-git-send-email-cinifr@gmail.com>
 <1379852488-32147-2-git-send-email-cinifr@gmail.com>
 <20130923181707.GR2779@lukather>
 <CAK3cCBwLrnV7L9WzJ+1P_62PEjEEtgzVjFH8m6SZzWG1O+2vEw@mail.gmail.com>
 <20130925184435.GH2954@lukather>
 <CAK3cCBwOpkk5ObeEm+by=RS6jSptPdGZM+fvpgGZpX9TPij5gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <CAK3cCBwOpkk5ObeEm+by=RS6jSptPdGZM+fvpgGZpX9TPij5gg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Fan,

On Sat, Sep 28, 2013 at 09:48:11PM +0800, cinifr wrote:
> Hi  Maxime,
>     I have test it, but I found it does not work. If using
> smp_prepare_cpus, the kernenl cannot find the secondary cpus because
> that smp_prepare_cpus semms not be excuted before kernel is booting
> secondary cpus. So I have to use early_initcall.

At least two other platforms (sti and rockchip) do it like that.

And an early_initcall is not an option.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSSasNAAoJEBx+YmzsjxAgi5IP/2icGkG2a/zHtsHryi3XkEH1
A1C6dEKqgk7wrxPyibdvMpsre4V/scPrTR66U0MzfQWQs5pNapxgsm4p2tCC0n85
XdFMMqgPmeUIK0yi3IOFJgkveW6G3F/Ba+FZnhKGVIrg3iy2dhgslOnpuUoBNiLM
hCOVqYNuoYMD5buJ8uRJ1gORgen4LRRktxrOtdS1InYspQG2EAukK38+aU++SH+f
0beSsUd73QBOMYiqqAh9+gk8sVWi0kH1WzmBzdBs6svVAMRlLSGZyGPXwtCJYmYl
IR+hwsqoSrdIXsNb2nkgVWt6Rt1oQKjTNiCjn8VAy/yCUs/t2pdjVGBbVoDYeRmL
D+oz5/IscApNLipyOaLVowOtmAsqofjSPWIXocIbnGc7bH7yJ1MvfWZp8Dnzvt+b
MO8ciNrQnWbjpDLzRmA5/FokC+gQkhpZ61EsEmgwNSgejQ5m/kiqTtUa3XWipxsS
6Pdl/BZRkStKI8tnLkpq90cuoG0jJJgLD3WNEtu9vowJzbX25F/5jM3TtfS8QV90
IY2ksGnSjHblEdvKrUl6UI3vPWbh887LPhmqUj0QWyJYliTbG+iny/lUd4VwLfic
6Lsbq1X8Rw/tbXR8Oj3Tm0vRm3t1lETKW54WdzLIdWsqIAs7KVAN+G4KWK8QZEmT
RLD9AIDGOf6nXwDtoOFJ
=/drZ
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
