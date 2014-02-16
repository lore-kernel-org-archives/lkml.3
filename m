Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaBPJF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 04:05:29 -0500
Received: from mout.web.de ([212.227.15.4]:57688 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbaBPJFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 04:05:23 -0500
Message-ID: <53007F4F.8090309@web.de>
Date: Sun, 16 Feb 2014 10:05:19 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] intel_idle: Add CPU model 54 (Atom N2000 series)
References: <52E42B86.1020701@web.de> <CAJvTdKnt=75AEQhsa8aAdEft7nnySvhxc57_1BHmOS7+tbLeNQ@mail.gmail.com> <52F9B88E.3090601@web.de>
In-Reply-To: <52F9B88E.3090601@web.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="NpK3n2rNXt9TgMxCtgrg9d8xU0n7GopW2"
X-Provags-ID: V03:K0:7rQiCJakwtqCafjdkagA1y05Qeatktkzx4QWXM6uVHV7vKBL1Kz
 tsu5maUuuZHr3B1YIPW9g3Bux8T5wwUAhWqjxvsiWoGgZOxAHf7s8GdzCO/DJ5zRMKX/jgt
 +Ja7DEOK+R1avFV2bVLkREpFXfpkuXwT2ZGbNNiJAjl1ekbYqQK90BASfQcfOjrH+EYIN1p
 9YnVz8pHwoUx0Ew8qN/iw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NpK3n2rNXt9TgMxCtgrg9d8xU0n7GopW2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-02-11 06:43, Jan Kiszka wrote:
> On 2014-02-11 01:01, Len Brown wrote:
>> Please send the output of these two command before and after the patch=
:
>>
>> dmesg | grep idle
>> grep . /sys/devices/system/cpu/cpu0/cpuidle/*/*
>=20
> Before:
> # dmesg | grep idle
> [    0.648783] cpuidle: using governor ladder
> [    0.648787] cpuidle: using governor menu
> [    1.053215] intel_idle: does not run on family 6 model 54
> [    3.285430] ACPI: acpi_idle registered with cpuidle
> # grep . /sys/devices/system/cpu/cpu0/cpuidle/*/*
> /sys/devices/system/cpu/cpu0/cpuidle/state0/desc:CPUIDLE CORE POLL IDLE=

> /sys/devices/system/cpu/cpu0/cpuidle/state0/disable:0
> /sys/devices/system/cpu/cpu0/cpuidle/state0/latency:0
> /sys/devices/system/cpu/cpu0/cpuidle/state0/name:POLL
> /sys/devices/system/cpu/cpu0/cpuidle/state0/power:4294967295
> /sys/devices/system/cpu/cpu0/cpuidle/state0/time:443
> /sys/devices/system/cpu/cpu0/cpuidle/state0/usage:5
> /sys/devices/system/cpu/cpu0/cpuidle/state1/desc:ACPI FFH INTEL MWAIT 0=
x0
> /sys/devices/system/cpu/cpu0/cpuidle/state1/disable:0
> /sys/devices/system/cpu/cpu0/cpuidle/state1/latency:1
> /sys/devices/system/cpu/cpu0/cpuidle/state1/name:C1
> /sys/devices/system/cpu/cpu0/cpuidle/state1/power:0
> /sys/devices/system/cpu/cpu0/cpuidle/state1/time:420944
> /sys/devices/system/cpu/cpu0/cpuidle/state1/usage:1798
> /sys/devices/system/cpu/cpu0/cpuidle/state2/desc:ACPI FFH INTEL MWAIT 0=
x10
> /sys/devices/system/cpu/cpu0/cpuidle/state2/disable:0
> /sys/devices/system/cpu/cpu0/cpuidle/state2/latency:20
> /sys/devices/system/cpu/cpu0/cpuidle/state2/name:C2
> /sys/devices/system/cpu/cpu0/cpuidle/state2/power:0
> /sys/devices/system/cpu/cpu0/cpuidle/state2/time:119479360
> /sys/devices/system/cpu/cpu0/cpuidle/state2/usage:32863
> /sys/devices/system/cpu/cpu0/cpuidle/state3/desc:ACPI FFH INTEL MWAIT 0=
x30
> /sys/devices/system/cpu/cpu0/cpuidle/state3/disable:0
> /sys/devices/system/cpu/cpu0/cpuidle/state3/latency:100
> /sys/devices/system/cpu/cpu0/cpuidle/state3/name:C3
> /sys/devices/system/cpu/cpu0/cpuidle/state3/power:0
> /sys/devices/system/cpu/cpu0/cpuidle/state3/time:1673
> /sys/devices/system/cpu/cpu0/cpuidle/state3/usage:7
> /sys/devices/system/cpu/cpu0/cpuidle/state4/desc:ACPI FFH INTEL MWAIT 0=
x52
> /sys/devices/system/cpu/cpu0/cpuidle/state4/disable:0
> /sys/devices/system/cpu/cpu0/cpuidle/state4/latency:140
> /sys/devices/system/cpu/cpu0/cpuidle/state4/name:C4
> /sys/devices/system/cpu/cpu0/cpuidle/state4/power:0
> /sys/devices/system/cpu/cpu0/cpuidle/state4/time:125622
> /sys/devices/system/cpu/cpu0/cpuidle/state4/usage:63
>=20
> After:
> # dmesg | grep idle
> [    0.244640] cpuidle: using governor ladder
> [    0.244645] cpuidle: using governor menu
> [    0.654351] intel_idle: MWAIT substates: 0x3020220
> [    0.654355] intel_idle: v0.4 model 0x36
> [    0.654359] intel_idle: lapic_timer_reliable_states 0xffffffff
> # grep . /sys/devices/system/cpu/cpu0/cpuidle/*/*
> /sys/devices/system/cpu/cpu0/cpuidle/state0/desc:CPUIDLE CORE POLL IDLE=

> /sys/devices/system/cpu/cpu0/cpuidle/state0/disable:0
> /sys/devices/system/cpu/cpu0/cpuidle/state0/latency:0
> /sys/devices/system/cpu/cpu0/cpuidle/state0/name:POLL
> /sys/devices/system/cpu/cpu0/cpuidle/state0/power:4294967295
> /sys/devices/system/cpu/cpu0/cpuidle/state0/time:572
> /sys/devices/system/cpu/cpu0/cpuidle/state0/usage:12
> /sys/devices/system/cpu/cpu0/cpuidle/state1/desc:MWAIT 0x00
> /sys/devices/system/cpu/cpu0/cpuidle/state1/disable:0
> /sys/devices/system/cpu/cpu0/cpuidle/state1/latency:10
> /sys/devices/system/cpu/cpu0/cpuidle/state1/name:C1E-ATM
> /sys/devices/system/cpu/cpu0/cpuidle/state1/power:0
> /sys/devices/system/cpu/cpu0/cpuidle/state1/time:722013
> /sys/devices/system/cpu/cpu0/cpuidle/state1/usage:3132
> /sys/devices/system/cpu/cpu0/cpuidle/state2/desc:MWAIT 0x10
> /sys/devices/system/cpu/cpu0/cpuidle/state2/disable:0
> /sys/devices/system/cpu/cpu0/cpuidle/state2/latency:20
> /sys/devices/system/cpu/cpu0/cpuidle/state2/name:C2-ATM
> /sys/devices/system/cpu/cpu0/cpuidle/state2/power:0
> /sys/devices/system/cpu/cpu0/cpuidle/state2/time:4512127
> /sys/devices/system/cpu/cpu0/cpuidle/state2/usage:9147
> /sys/devices/system/cpu/cpu0/cpuidle/state3/desc:MWAIT 0x30
> /sys/devices/system/cpu/cpu0/cpuidle/state3/disable:0
> /sys/devices/system/cpu/cpu0/cpuidle/state3/latency:100
> /sys/devices/system/cpu/cpu0/cpuidle/state3/name:C4-ATM
> /sys/devices/system/cpu/cpu0/cpuidle/state3/power:0
> /sys/devices/system/cpu/cpu0/cpuidle/state3/time:1996954
> /sys/devices/system/cpu/cpu0/cpuidle/state3/usage:2696
> /sys/devices/system/cpu/cpu0/cpuidle/state4/desc:MWAIT 0x52
> /sys/devices/system/cpu/cpu0/cpuidle/state4/disable:0
> /sys/devices/system/cpu/cpu0/cpuidle/state4/latency:140
> /sys/devices/system/cpu/cpu0/cpuidle/state4/name:C6-ATM
> /sys/devices/system/cpu/cpu0/cpuidle/state4/power:0
> /sys/devices/system/cpu/cpu0/cpuidle/state4/time:266926331
> /sys/devices/system/cpu/cpu0/cpuidle/state4/usage:73695
>=20
>>
>> How did you measure power on the the DN2800MT, and on what workload?
>=20
> I measured the input current of the board @12V. In both cases, the
> system was idle in single-user mode, practically no processes running.
>=20
> Jan
>=20
>=20

Was this answering your questions sufficiently? Can it be merged?

Jan


--NpK3n2rNXt9TgMxCtgrg9d8xU0n7GopW2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMAf08ACgkQitSsb3rl5xQOKQCgwPovXV4q34kZThTcqVjSdQxM
TXgAn05rPkRmbig6jijexZ6Y5s30yKpV
=vmmd
-----END PGP SIGNATURE-----

--NpK3n2rNXt9TgMxCtgrg9d8xU0n7GopW2--
