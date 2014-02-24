Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaBXTik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:38:40 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:34024 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbaBXTij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:38:39 -0500
Message-ID: <530B9FB6.6000909@gmail.com>
Date: Mon, 24 Feb 2014 20:38:30 +0100
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@darnok.org>, Paul Bolle <pebolle@tiscali.nl>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, David Vrabel <david.vrabel@citrix.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        xen-devel@lists.xenproject.org, Thomas Gleixner <tglx@linutronix.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH] xen: remove XEN_PRIVILEGED_GUEST
References: <201402171223.s1HCNG0S023567@userz7022.oracle.com> <1392642197.13000.20.camel@x220> <20140217144307.GB28658@localhost.localdomain> <1392718467.30073.12.camel@x220> <20140224183939.GA26794@andromeda.dapyr.net>
In-Reply-To: <20140224183939.GA26794@andromeda.dapyr.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="LQf9i8dCwxhQ225O9gpBO8F1we7xlHuSU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LQf9i8dCwxhQ225O9gpBO8F1we7xlHuSU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 24.02.2014 19:39, Konrad Rzeszutek Wilk wrote:
> On Tue, Feb 18, 2014 at 11:14:27AM +0100, Paul Bolle wrote:
>> On Mon, 2014-02-17 at 09:43 -0500, Konrad Rzeszutek Wilk wrote:
>>> On Mon, Feb 17, 2014 at 02:03:17PM +0100, Paul Bolle wrote:
>>>> On Mon, 2014-02-17 at 07:23 -0500, Konrad Rzeszutek Wilk wrote:
>>>>> On Feb 16, 2014 3:07 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
>>>>> Please look in the grub git tree. They have fixed their code to not=
 do
>>>>> this anymore. This should be reflected in the patch description.
>>>>
>>>> Thanks, I didn't know that. That turned out to be grub commit
>>>> ec824e0f2a399ce2ab3a2e3353d372a236595059 ("Implement grub_file tool =
and
>>>> use it to implement generating of config"), see
>>>> http://git.savannah.gnu.org/cgit/grub.git/commit/util/grub.d/20_linu=
x_xen.in?id=3Dec824e0f2a399ce2ab3a2e3353d372a236595059
>>
>> And that commit was reverted a week later in grub commit
>> faf4a65e1e1ce1d822d251c1e4b53d96ec7faec5 ("Revert grub-file usage in
>> grub-mkconfig."), see
>> http://git.savannah.gnu.org/cgit/grub.git/commit/util/grub.d/20_linux_=
xen.in?id=3Dfaf4a65e1e1ce1d822d251c1e4b53d96ec7faec5 .
>>
>> That commit has no explanation (other than its one line summary). So
>> we're left guessing why this was done. Luckily, it doesn't matter here=
,
>> because the test for CONFIG_XEN_PRIVILEGED_GUEST is superfluous.
>=20
> How about we ask Vladimir?
>=20
> Vladimir - could you shed some light on it? Thanks!
>=20
CONFIG_XEN_PRIVILEGED_GUEST is not present on Linux even though it
should be. The test was removed to accomodate this.
The usage of grub-file was removed because it wasn't release-ready.
>>
>> Anyhow, I hope to submit a second version of this patch later this day=
=2E
>>
>>
>> Paul Bolle
>>
>>
>> _______________________________________________
>> Xen-devel mailing list
>> Xen-devel@lists.xen.org
>> http://lists.xen.org/xen-devel
>=20



--LQf9i8dCwxhQ225O9gpBO8F1we7xlHuSU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iF4EAREKAAYFAlMLn7YACgkQmBXlbbo5nOv3vAEAhYBDk5smbGM/jU0PN1s8AeqY
7wx2lLEzfo9PQQb1un0A/RRsx0iyQr64+f7mliQolZwGN4uG8ioP/TD4lMh/LZox
=Ziei
-----END PGP SIGNATURE-----

--LQf9i8dCwxhQ225O9gpBO8F1we7xlHuSU--
