Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbaADXeB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 18:34:01 -0500
Received: from ozlabs.org ([203.10.76.45]:55965 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939AbaADXd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 18:33:59 -0500
Date: Sun, 5 Jan 2014 10:33:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/3] kconfig: consolidate arch-specific seccomp options
Message-Id: <20140105103353.9bf06782c851f8eaec0e0f33@canb.auug.org.au>
In-Reply-To: <52C85B34.6040001@sr71.net>
References: <20140102202014.CA206E9B@viggo.jf.intel.com>
	<20140105023853.dda6c1f9c6f9875159634e69@canb.auug.org.au>
	<52C85B34.6040001@sr71.net>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__5_Jan_2014_10_33_53_+1100_Xdx2b_+gSyIFCvcN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__5_Jan_2014_10_33_53_+1100_Xdx2b_+gSyIFCvcN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Sat, 04 Jan 2014 11:04:20 -0800 Dave Hansen <dave@sr71.net> wrote:
>
> On 01/04/2014 07:38 AM, Stephen Rothwell wrote:
> > On Thu, 02 Jan 2014 12:20:14 -0800 Dave Hansen <dave@sr71.net> wrote:
> >> From: Dave Hansen <dave.hansen@linux.intel.com>
> >> There is *NOTHING* architecture-specific about SECCOMP except
> >> that the syscalls have per-architecture definitions, like every
> >> other syscall.  It is absurd to have the option in the
> >> arch-specific menus.
> >=20
> > You seem to have (mostly) lost the dependency some of the architecture
> > versions of config SECCOMP had on PROC_FS ...
>=20
> I _believe_ the /proc interface has gone away.  I can't find any
> reference to /proc/<pid>/seccomp in any of the code.  Is there some
> /proc dependency that I'm missing outside of the removed
> /proc/<pid>/seccomp interface?

I don't know, but if it has gone then it is worth mentioning in the
commit message ... and you did preserve the dependency in the sparc64
case.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__5_Jan_2014_10_33_53_+1100_Xdx2b_+gSyIFCvcN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSyJpmAAoJEMDTa8Ir7ZwVZ9MP/0Rzml0PVSjq47Y4DZrLpTnY
fOzJkEpH3234nQNHt84eJNYRivdWNkn+zmSLlSzL5I6KvKG0EFdmgU5q7bNXa3xf
un0/EZ31nL5bassoyQOHRXU5tYtvGQ98MNW6rE4btLNaYMvRY7e91Z8ldjsREsAE
z+9JQWU18CUVDTfXrY+Fxv1/M4sIjNRo4uc6sAEa0lgolXJzkcgEUW4xyZiHx6Vw
D34sPIwVVHzmmEqrkhWVj3LBsdH0FiRJ/mtLC7vcFIjzQw4rV5/x8mjGOqCCHCdm
YChlh/D6z97ofEgrFOHXzi4HepH4Tx34RB2kjxaPxPBuWDMYgFSKdihm7Cuu+Mwy
oUMmVfqYyj618oFBW+cyqT7h3EmzOaXvP4RfY9ReeWSRMi+r5gjnV86yND2jdeFP
XwaLD37DDgJJZGUYohoGgYZtuJEt9cHtHilJimBcgFdaoNrbNMY/fUvaA6y4EPOJ
3g2XLkO2klUOi6S7kfaXlRsegu3wRMAv8nK9x6or+GPLox6fHCrGjjIK3sMecKZT
GXvxi14WGmZk4SajN3diQOnr8oCxOOasHPW4xIy4kVlkBIC5zAeW/Zc9nmB49g7p
KDu7S6HMgU8uuQXVM1GHLb4QrMPrSogjsyWPt0UI552Mc079h9/ITN6/4iGwpQz5
+UONFWEeXLEAjeZAGiKz
=1oIO
-----END PGP SIGNATURE-----

--Signature=_Sun__5_Jan_2014_10_33_53_+1100_Xdx2b_+gSyIFCvcN--
