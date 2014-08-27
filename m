Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936013AbaH0VoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:44:14 -0400
Received: from ozlabs.org ([103.22.144.67]:37069 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246AbaH0VoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:44:12 -0400
Date: Thu, 28 Aug 2014 07:43:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH percpu/for-3.18-consistent-ops] Revert "powerpc: Replace
 __get_cpu_var uses"
Message-ID: <20140828074349.10e86372@canb.auug.org.au>
In-Reply-To: <20140827152609.GA379@htj.dyndns.org>
References: <20140827142243.6277eaff@canb.auug.org.au>
	<20140827152609.GA379@htj.dyndns.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/v9C9XSejlPdll_VzAr9GM0m"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/v9C9XSejlPdll_VzAr9GM0m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Wed, 27 Aug 2014 11:26:09 -0400 Tejun Heo <tj@kernel.org> wrote:
>
> From 23f66e2d661b4d3226d16e25910a9e9472ce2410 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Wed, 27 Aug 2014 11:18:29 -0400
>=20
> This reverts commit 5828f666c069af74e00db21559f1535103c9f79a due to
> build failure after merging with pending powerpc changes.

I can't see any pending powerpc changes that would obviously affect
this ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/v9C9XSejlPdll_VzAr9GM0m
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT/lEpAAoJEMDTa8Ir7ZwVSJQQAI11s87rXAq2tFeFq4Sp68/N
e61NZEJZL01zYZay7wR54t1OVVUJAVhaMVMgLGBXH+3noDq7UYClgaJeHKbbVcUI
Fl9TOUyLVQ/IxU54uhhTAMge+PQ1657Yxwb+PFUPWcAgTSW3MamxOx9rLgXUDuFK
rrZ1O7oQCclc0LOr00EuYFeUGf4l+PxZYI840d3iyRhOahBW5rcgIopq1UbNQRSH
bB/++eK7JC7zNBq3lgPp/XA5l/FzUxLB728xByBwmZrp9iGcUjnPmZp4DT3h0k7Z
n2HHcDVgynuClLZFjFCFVUmd1kgqibMAPb+ML1+d1GjNMpGMWwnojJjz/4eKKnHU
F7Q+LF93tNl7Aq/UHruslawnPD/EAf791vZi7G8LCM21vtAXziWxli9K/3wPgWIh
Er75kayywlX61beXVoQIxmKfR8Iki+kEParVuIut7B2LJEbr65T6aT3dxQ8Fzz4e
w9vyIHBWe7WaXAMOT+OuLpq+FvcljCWUgD9jJ0C9nSh7E6cO/vy++a9FcO9XK/pF
h6hkxWp7ySnqtp/1s3VNFS/AJQQAbb3QaeuaovLqJ6ncNSBPN/JQH3Hax3DgG5tz
KeD1sCrr0mYW2f9apRTQCQK3tPhpLHwOl5xo310asJWhoo/mqbDn+S/Y1uvZrqsE
aY4jpA1qcYAlDKu7UvUG
=2nka
-----END PGP SIGNATURE-----

--Sig_/v9C9XSejlPdll_VzAr9GM0m--
