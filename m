Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbaAFOyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:54:39 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41268 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588AbaAFOyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:54:37 -0500
Message-ID: <52CAC376.9090904@ti.com>
Date: Mon, 6 Jan 2014 10:53:42 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <linux-pm@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 0/7] DRA7: DT thermal support
References: <1389011811-13004-1-git-send-email-eduardo.valentin@ti.com> <1389019601.5853.17.camel@rzhang1-mobl4>
In-Reply-To: <1389019601.5853.17.camel@rzhang1-mobl4>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="w6hnwxrXBm0kRrQdU5k1tdEDS4bAT4JMd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--w6hnwxrXBm0kRrQdU5k1tdEDS4bAT4JMd
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06-01-2014 10:46, Zhang Rui wrote:
> On Mon, 2014-01-06 at 08:36 -0400, Eduardo Valentin wrote:
>> Hello all,
>>
>> Now that the basic thermal DT support is merged into Rui's tree,
>> I am resending this series, which introduces the DT node entries
>> for DRA7 thermal limits representation.
>>
>> The series adds two thermal zones, to represent IVA and DSPEVE,
>> respectively. It also adds the support to tmp102 and a corresponding
>> pcb thermal zone.
>>
>> There are only cosmetic changes from v1. A couple of spaces and tabula=
tions
>> have been fixed, and minor changes in sentences present in commit log.=

>> One difference from V1 is the fact that now bandgap is introduced unde=
r
>> OCP, which is also a minor diff.
>>
>> This patch series has been runtime tested on DRA7-evm.
>>
>> All best
>>
>> Eduardo Valentin (7):
>>   arm: dts: add dra7 DSPEVE thermal data
>>   arm: dts: add dra7 IVA thermal data
>>   arm: dts: dra7: add bandgap entry
>>   arm: dts: add cooling properties on dra7 cpu node
>>   arm: dts: dra7: add thermal data
>>   arm: dts: add tmp102 i2c sensor node on dra7-evm
>>   arm: dts: add thermal zones info on tmp102 for DRA7-EVM
>>
>>  arch/arm/boot/dts/dra7-dspeve-thermal.dtsi | 28 +++++++++++++++++++++=
+++++++
>>  arch/arm/boot/dts/dra7-evm.dts             | 22 +++++++++++++++++++++=
+
>>  arch/arm/boot/dts/dra7-iva-thermal.dtsi    | 28 +++++++++++++++++++++=
+++++++
>>  arch/arm/boot/dts/dra7.dtsi                | 26 +++++++++++++++++++++=
+++++
>=20
> I'm okay with this patch set. But as long as this patch set does not
> change any code under drivers/thermal/, I prefer these patches to go to=

> your thermal-soc tree first.

No problem at all. I will be queuing them.

>=20
> thanks,
> rui
>>  4 files changed, 104 insertions(+)
>>  create mode 100644 arch/arm/boot/dts/dra7-dspeve-thermal.dtsi
>>  create mode 100644 arch/arm/boot/dts/dra7-iva-thermal.dtsi
>>
>=20
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--w6hnwxrXBm0kRrQdU5k1tdEDS4bAT4JMd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLKw3YACgkQCXcVR3XQvP2/uAD/bZAlE/r1chLoSmSNEJwIKarW
hrXPyIVW/uSA8EzXbpQA/Ahtvyl+C33hCCSRuCntJXbU9LXHluIoieQOAJv0Ty45
=TlPi
-----END PGP SIGNATURE-----

--w6hnwxrXBm0kRrQdU5k1tdEDS4bAT4JMd--
