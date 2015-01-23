Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbbAWBKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 20:10:21 -0500
Received: from ozlabs.org ([103.22.144.67]:34346 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbbAWBKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 20:10:18 -0500
Date: Fri, 23 Jan 2015 12:10:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Moore <pmoore@redhat.com>
Subject: linux-next: manual merge of the vfs tree with Linus' tree
Message-ID: <20150123121009.2ed32a2b@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/V9dPqSKYD_MXF_wWwEtUxKB"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/V9dPqSKYD_MXF_wWwEtUxKB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
kernel/auditsc.c between commit fcf22d8267ad ("audit: create private
file name copies when auditing inodes") from Linus' tree and various
commits from the vfs tree.

I fixed it up (I used the vfs tree version as advised by Al) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/V9dPqSKYD_MXF_wWwEtUxKB
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUwZ94AAoJEMDTa8Ir7ZwVzgMP/jj6IwySbZZCiPotgrEcRRvh
8LlimPOMH+S81lsoa9QmcIW52DOyIeQFKsyqNvpRSRc6pvrLqWq8I8iYECWw2mue
D4EXLjZh4I83HaYVuNQtHu2eQkusBCd4q0VXM4Tv0Qc+DjT+BOkm4fC2SAYQ2o9N
oPH6rXtQ9wTYdrJZoy4ovGAWNYS6Vajti47hVy1ECu+/VmN2vH39rbExo9oXYNCj
6I+ifJgASDbX2xXsP8b7sgC58UA8XEGimHuFljI1rXFqd45EO89O9KPVfuImRPb/
r7GoUNpdE+ko55wVpkYlJkp07k8IkMcPQXuA0hTnRFeCXvb1Zppsw2R0ZO+wCMKz
nOV3ilv4Ihn9EUMx48A0J8J0P5/kFL9fylu5QL1U19ZAjK/WHZzpzLX0/i/zKQI0
fTEmFJ+GSsUEJlxH5zXV3JzKJxghf/B77aS3kR7fuMYJC2jieqK+dwGMaRvAKCTe
nV8mecFZhNMErhreYZhqXlm+vRmjF+Sur03qkiXJ1ArNUuDw3IlHSMzp8nMKxiNd
lYU+FxMBGueNe5PkCTubdEkE+A0wzykzKs8WKai0Am2MDWnRB+xiyhp/qaxgCXHt
P/bwUCqW/88+F4MXZJHyKtiUoMhf7OI7bXm7D6NiD+ob1q/A4v73qs1NNRXJvphv
ZRLTDw94CLgEI+P1/CLG
=8Zri
-----END PGP SIGNATURE-----

--Sig_/V9dPqSKYD_MXF_wWwEtUxKB--
