Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392Ab3JOOJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:09:20 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57009 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759170Ab3JOOJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:09:19 -0400
Message-ID: <525D4C83.706@ti.com>
Date: Tue, 15 Oct 2013 10:09:07 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <amit.daniel@samsung.com>,
        <l.majewski@samsung.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [GIT PULL] thermal-soc: urgent fixes for 3.12
References: <1381788001-3508-1-git-send-email-eduardo.valentin@ti.com> <1381837008.2080.61.camel@rzhang1-mobl4>
In-Reply-To: <1381837008.2080.61.camel@rzhang1-mobl4>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="ebKEhHHIFAPP4n0G4vvmt0hFlUOeHGSww"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ebKEhHHIFAPP4n0G4vvmt0hFlUOeHGSww
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 15-10-2013 07:36, Zhang Rui wrote:
> Hi, Eduardo,
>=20
> On Mon, 2013-10-14 at 18:00 -0400, Eduardo Valentin wrote:
>> Hello Rui,
>>
>> Please pull the following changes. It contains fixes for 3.12 on Exyno=
s
>> thermal driver, which is currently broken, Exynos4412 is the main affe=
cted.
>> Thanks Lukasz for his persistence on getting this done for 3.12.
>>
>> Lukasz, you need to queue the remaining changes on DT via your platfor=
m tree.
>>
>> It contains also a fix on the extrapolation rules for TI SoCs.
>>
>> The following changes since commit 74ae45a3d656d3e86bb8e776634ebdfd3f3=
9f37c:
>>
>>   Merge branches 'x86_pkg_temp' and 'misc' of .git into next (2013-09-=
25 21:41:44 +0800)
>>
> please rebase your tree on top of my master branch or Linus' tree.
> Or else I'll pull in some thermal changes in my next branch that are
> targeted for 3.13.

In fact, my bad. I am rebasing on top of your master and resending.

>=20
> thanks,
> rui
>> are available in the git repository at:
>>
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-the=
rmal.git next
>>
>> for you to fetch changes up to 848a3b2b91a45f6b7814e2779f58cc0461d88fc=
e:
>>
>>   drivers: thermal: allow ti-soc-thermal run without pcb zone (2013-10=
-14 17:48:33 -0400)
>>
>> ----------------------------------------------------------------
>> Eduardo Valentin (1):
>>       drivers: thermal: allow ti-soc-thermal run without pcb zone
>>
>> Lukasz Majewski (3):
>>       thermal: exynos: Remove check for thermal device pointer at exyn=
os_report_trigger()
>>       thermal: exynos: Provide separate TMU data for Exynos4412
>>       thermal: exynos: Provide initial setting for TMU's test MUX addr=
ess at Exynos4412
>>
>>  drivers/thermal/samsung/exynos_thermal_common.c    |  2 --
>>  drivers/thermal/samsung/exynos_tmu.c               | 12 ++++++---
>>  drivers/thermal/samsung/exynos_tmu.h               |  7 ++++-
>>  drivers/thermal/samsung/exynos_tmu_data.c          | 30 +++++++++++++=
++++-----
>>  drivers/thermal/samsung/exynos_tmu_data.h          | 13 +++++++++-
>>  drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  1 +
>>  6 files changed, 51 insertions(+), 14 deletions(-)
>=20
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--ebKEhHHIFAPP4n0G4vvmt0hFlUOeHGSww
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJdTIUACgkQCXcVR3XQvP0qxAEAuaabRtfGK1pnfarqG3hufqJk
QkCGFtQf4M6LP3oHYU8BAOmVdgYaKh2McVCbx4WlFCARJSS33TUGV4xV6ZZ1UJiQ
=GBzs
-----END PGP SIGNATURE-----

--ebKEhHHIFAPP4n0G4vvmt0hFlUOeHGSww--
