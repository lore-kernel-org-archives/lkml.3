Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108AbaKVHbL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 02:31:11 -0500
Received: from mout.web.de ([212.227.15.14]:60571 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbaKVHbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 02:31:10 -0500
Message-ID: <54703BB4.1040306@web.de>
Date: Sat, 22 Nov 2014 08:31:00 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Wincy Van <fanwenyi0529@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bandan Das <bsd@redhat.com>
Subject: Re: [PATCH] KVM: nVMX: nested MSR auto load/restore emulation.
References: <CACzj_yU3evDWQdPbNHgE5sk_rJZicVfPhBG7K3J_wO2fQt5dcg@mail.gmail.com>
In-Reply-To: <CACzj_yU3evDWQdPbNHgE5sk_rJZicVfPhBG7K3J_wO2fQt5dcg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="PnTrIEkFrp5pO97DM6BmHWWUnuF717M5p"
X-Provags-ID: V03:K0:CLdN0bhZiLAfkdk+OidWusyNM2zt/Su45sO1Ut8+pLlykBmvu+w
 bkl0sR9qNjqGd/CBnbp5z6UPDQ6ahvXwYz9NDqUDOdHzUsv93QcSF4rLkK9dtqzTMU3w06o
 LoYEL0GwtFzlOwpsjKwB8uMG6VHv9K5CXQAkCwJjuudDoLmEnZIxmzcuemzRJAxf1+Vc2Ew
 s4+Qq3U/Go/wn72bctl9w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PnTrIEkFrp5pO97DM6BmHWWUnuF717M5p
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2014-11-22 05:24, Wincy Van wrote:
> Some hypervisors need MSR auto load/restore feature.
>=20
> We read MSRs from vm-entry MSR load area which specified by L1,
> and load them via kvm_set_msr in the nested entry.
> When nested exit occurs, we get MSRs via kvm_get_msr, writting
> them to L1`s MSR store area. After this, we read MSRs from vm-exit
> MSR load area, and load them via kvm_set_msr.
>=20
> VirtualBox will work fine with this patch.

Cool! This feature is long overdue.

Patch is unfortunately misformatted which makes it very hard to read.
Please check via linux/scripts/checkpatch.pl for the proper style.

Could you also write a corresponding kvm-unit-test (see x86/vmx_tests.c)?=


Jan



--PnTrIEkFrp5pO97DM6BmHWWUnuF717M5p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlRwO7QACgkQitSsb3rl5xQwFgCfY0UXBsAiyB8Xefv1k/rbsJUx
CkoAoIq4bRZd5lFrp2Iwkd+PCNj21Wm3
=dX3X
-----END PGP SIGNATURE-----

--PnTrIEkFrp5pO97DM6BmHWWUnuF717M5p--
