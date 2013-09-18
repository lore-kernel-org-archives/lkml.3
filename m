Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab3IRBuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 21:50:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46340 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3IRBuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 21:50:13 -0400
Date: Wed, 18 Sep 2013 11:50:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>, simo@redhat.com,
        zohar@linux.vnet.ibm.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Keyrings patches
Message-Id: <20130918115000.b78a5e79d65aa23ced0ac8e4@canb.auug.org.au>
In-Reply-To: <19686.1379426149@warthog.procyon.org.uk>
References: <alpine.LRH.2.02.1309120141280.4317@tundra.namei.org>
	<alpine.LRH.2.02.1309071426400.29124@tundra.namei.org>
	<alpine.LRH.2.02.1309070309360.24160@tundra.namei.org>
	<12075.1378340063@warthog.procyon.org.uk>
	<17000.1378488989@warthog.procyon.org.uk>
	<10114.1378806359@warthog.procyon.org.uk>
	<19686.1379426149@warthog.procyon.org.uk>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__18_Sep_2013_11_50_00_+1000_iTHFaSFaH2.XpTNi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Sep_2013_11_50_00_+1000_iTHFaSFaH2.XpTNi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Tue, 17 Sep 2013 14:55:49 +0100 David Howells <dhowells@redhat.com> wrot=
e:
>
> There's a slight change upstream that means that my patchset needs
> regenerating (the initconst changes).  Can you bring your -next branch up=
 to
> date with linus/master so that I can rebase on top of it?

Is there some reason that those fixups cannot be done in a merge commit?
i.e. are they more than simple text updates?

/me thinks that most rebases people do can be better done (and
documented) as merges.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__18_Sep_2013_11_50_00_+1000_iTHFaSFaH2.XpTNi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSOQbNAAoJEECxmPOUX5FEyzoP/ic3Km95fvhaDOJMemJZAXz6
UOpTTkUrW/Gty8S9o3/2xdfSsbHDx+r1PlVwRt4qojEBfe0aozFiNaEDV9VbOWYS
HOKxeS/kj4lGBEcZsd8Rf8qQo0FVvZlyTmhTA2Uu/3yMxT9dgdGmyeDGM4BsXI1G
SStqOQ8aImybUNqeH/bAk3sv5v2Q5MePs3d2mU1Jw5S9q0mUfJ9XQXWvKzeFxvlc
XcO9CdPfbYiRkEulect1dnSNV8JjOcx2HvgUabA0yT9meV/2VycQuxNw1Dlc4N16
vgxVSgfSZvKKUf3aoONxFv7RCcmPtbrOSNus0rSEgY3zcmXDMjTpWXZnSq64dgJo
kAEAwHUObehIcEUondjxstGc1Sf8cjE+ooHV8p9xFFRhQIUgDNcLNaYxKaMw3Uru
2cGVWY9vmdFCXPGwKU/eeJoCm4XGyVv46FhIXfXNI+FAFsmI0ltO4Yk8j8gsY3Mq
IkCRThDvuwVRaL72Nbb3NI9sy+fhs+iafvOmCyyOZlUhto8cXJaA57gYOGSccekV
xQzD02R7lN9B8m3SjYfgG7hHPgOjILnDR/k1YkMTSt0qwMhu2tcvgOdaOBN3TmUE
xOz8BXEdgvJcmDCWygTHnB7HsIG90/BovTvawfijmDF9k6bZ7XgArpwDvo+koabm
3HODI+rFukV5AZzIxrg2
=6EAe
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Sep_2013_11_50_00_+1000_iTHFaSFaH2.XpTNi--
