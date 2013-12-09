Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761553Ab3LIXKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:10:40 -0500
Received: from ozlabs.org ([203.10.76.45]:33720 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761250Ab3LIXKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:10:37 -0500
Date: Tue, 10 Dec 2013 10:10:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-next <linux-next@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc: Fix "attempt to move .org backwards" error
Message-Id: <20131210101031.82b02468d32ddb89481b24b9@canb.auug.org.au>
In-Reply-To: <20131209191015.22974.31604.stgit@mars>
References: <20131209191015.22974.31604.stgit@mars>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Dec_2013_10_10_31_+1100_7qir/92cL46bTkQr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Dec_2013_10_10_31_+1100_7qir/92cL46bTkQr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 10 Dec 2013 00:40:15 +0530 Mahesh J Salgaonkar <mahesh@linux.vnet.i=
bm.com> wrote:
>
> From: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
>=20
> With recent machine check patch series changes, The exception vectors
> starting from 0x4300 are now overflowing with allyesconfig. Fix that by
> moving machine_check_common and machine_check_handle_early code out of
> that region to make enough room for exception vector area.
>=20
> Fixes this build error reportes by Stephen:
>=20
> arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
> arch/powerpc/kernel/exceptions-64s.S:958: Error: attempt to move .org bac=
kwards
> arch/powerpc/kernel/exceptions-64s.S:959: Error: attempt to move .org bac=
kwards
> arch/powerpc/kernel/exceptions-64s.S:983: Error: attempt to move .org bac=
kwards
> arch/powerpc/kernel/exceptions-64s.S:984: Error: attempt to move .org bac=
kwards
> arch/powerpc/kernel/exceptions-64s.S:1003: Error: attempt to move .org ba=
ckwards
> arch/powerpc/kernel/exceptions-64s.S:1013: Error: attempt to move .org ba=
ckwards
> arch/powerpc/kernel/exceptions-64s.S:1014: Error: attempt to move .org ba=
ckwards
> arch/powerpc/kernel/exceptions-64s.S:1015: Error: attempt to move .org ba=
ckwards
> arch/powerpc/kernel/exceptions-64s.S:1016: Error: attempt to move .org ba=
ckwards
> arch/powerpc/kernel/exceptions-64s.S:1017: Error: attempt to move .org ba=
ckwards
> arch/powerpc/kernel/exceptions-64s.S:1018: Error: attempt to move .org ba=
ckwards
>=20
> Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>

Works for me.  Thanks.  I will add this to linux-next today if Ben
doesn't add it to his tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__10_Dec_2013_10_10_31_+1100_7qir/92cL46bTkQr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSpk3rAAoJEMDTa8Ir7ZwVUpgP/2ws9LuzBPRugUr9MLpkQG74
LxohsEzDr1BmqFrCbQrRUOWRtjp8NljrIlKzmzRM8yWKRLCJNZS5ukRbaBUQbWSK
bTacVhp4ea1ETTawiMCxy/OeBhqNHxQIhlA1MyHYnjTQ9WQ2k5Pe3dWAu+MtQQNT
Rxnla6vdYKWTzsyqk6KpCkpWopnu1rOtyVRVHcKDKbBFj2XWhtSziRcbEo1sfdOk
PhfAVP4Wm2b9ENXn0QWry5uvgbfI0vUh9fNGTovm1QG3qTfqu9CzjlwGqDOzrgF9
y9tCwcbGVL4kPD7sTHi1l94qJNOfCQhxh4ewoV/tL/yE4x4u3GFW4PxR6Eef5QCl
S3SZH35ex4o5/7Yh1Fk7exvPbDz9D7yDmP0ZO62KXiE9Lys4B84GTbObJm3g2XBX
3GvlXxTcWV06c8usCLQYxyALidlKr6P2KO8V/FkM5+RZAIetcv2dlNUzV/QT2PSO
a5yX4kxs/CqsVKLM9PvbUjXt/fR4GOyYfhClyjMqoL1l+iqvWW9If+PX5M2HSwu9
aAWSbOgcObuy4J3FagN39uwZIPqsAeBsp+3y2shC5uK7I2OYIjpuYW0Xwl9oNTHa
NbOgPSi+UN0plhsxSWJW8IVBJmfzXi3WYBQYVcvh1Epz0gdvhuGDjw/vWJFTjQrH
mvo7nJ9HdagQG1yvqCUr
=9MSl
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Dec_2013_10_10_31_+1100_7qir/92cL46bTkQr--
