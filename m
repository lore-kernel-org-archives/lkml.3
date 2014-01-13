Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaAMPKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:10:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38633 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaAMPKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:10:05 -0500
Message-ID: <52D4017D.7050400@ti.com>
Date: Mon, 13 Jan 2014 11:08:45 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Zhang, Rui" <rui.zhang@intel.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "wni@nvidia.com" <wni@nvidia.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "R, Durgadoss" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCHv5 05/20] cpufreq: cpufreq-cpu0: add dt node parsing for
 cooling device properties
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com> <1384285582-16933-6-git-send-email-eduardo.valentin@ti.com> <744357E9AAD1214791ACBA4B0B909263011C9A19@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <744357E9AAD1214791ACBA4B0B909263011C9A19@SHSMSX101.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="6w14OBBopNRxnkc23Fn6ofb3GQF7Pl6gc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6w14OBBopNRxnkc23Fn6ofb3GQF7Pl6gc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-01-2014 10:31, Zhang, Rui wrote:
>> +++ b/drivers/cpufreq/Kconfig
>> > @@ -186,7 +186,7 @@ config CPU_FREQ_GOV_CONSERVATIVE
>> >=20
>> >  config GENERIC_CPUFREQ_CPU0
>> >  	tristate "Generic CPU0 cpufreq driver"
>> > -	depends on HAVE_CLK && REGULATOR && PM_OPP && OF
>> > +	depends on HAVE_CLK && REGULATOR && PM_OPP && OF && THERMAL &&
>> > +CPU_THERMAL
> config: make ARCH=3Darm multi_v7_defconfig
> All warnings:
> warning: (ARM_HIGHBANK_CPUFREQ) selects GENERIC_CPUFREQ_CPU0 which=20
> has unmet direct dependencies (ARCH_HAS_CPUFREQ && CPU_FREQ &&=20
> HAVE_CLK && REGULATOR && PM_OPP && OF && THERMAL && CPU_THERMAL)
>=20
> I think you need to select THERMAL and CPU_THERMAL instead, right?
>=20

Yeah, I think that would be better. I will send you a fix for that.

--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--6w14OBBopNRxnkc23Fn6ofb3GQF7Pl6gc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLUAYEACgkQCXcVR3XQvP1DeAEAtnKafVtyvPO7Aa4m6IQtHL+5
YB9DVIxxyydT4d5qTHAA/jHNYC4nj97SiItKkcKO5lw0d6JhzWkAKc+CB4pBD2Ti
=blOg
-----END PGP SIGNATURE-----

--6w14OBBopNRxnkc23Fn6ofb3GQF7Pl6gc--
