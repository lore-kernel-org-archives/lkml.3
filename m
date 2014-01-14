Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaANTIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:08:51 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47748 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaANTIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:08:45 -0500
Message-ID: <52D58AEC.6020706@ti.com>
Date: Tue, 14 Jan 2014 15:07:24 -0400
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
	boundary="rqLhxVutw0XWqBrJW52q0JlnNclgB2BIN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rqLhxVutw0XWqBrJW52q0JlnNclgB2BIN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-01-2014 10:31, Zhang, Rui wrote:
> config: make ARCH=3Darm multi_v7_defconfig
> All warnings:
> warning: (ARM_HIGHBANK_CPUFREQ) selects GENERIC_CPUFREQ_CPU0 which=20
> has unmet direct dependencies (ARCH_HAS_CPUFREQ && CPU_FREQ &&=20
> HAVE_CLK && REGULATOR && PM_OPP && OF && THERMAL && CPU_THERMAL)

Rui,

BTW, I am not able to reproduce the above warning :-(

Are you sure you simply do a
$  make ARCH=3Darm multi_v7_defconfig

??

--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--rqLhxVutw0XWqBrJW52q0JlnNclgB2BIN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLViuwACgkQCXcVR3XQvP3RagD/Xt1EHXcz+FELfwfsdUrW+7R1
ScNyjka4lEYI14kCm0cBAKIqssi1UhKAhXv0aLfEw9BSW/lyNmIdALWHF+R4TpUx
=/xy1
-----END PGP SIGNATURE-----

--rqLhxVutw0XWqBrJW52q0JlnNclgB2BIN--
