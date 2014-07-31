Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbaGaGaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:30:35 -0400
Received: from ozlabs.org ([103.22.144.67]:41964 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169AbaGaGaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:30:12 -0400
Date: Thu, 31 Jul 2014 16:30:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: linux-next: manual merge of the kvm-arm tree with Linus' tree
Message-ID: <20140731163004.474501fb@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/m7KGpMGMqLmZz4zkVy7oExR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/m7KGpMGMqLmZz4zkVy7oExR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in
virt/kvm/arm/vgic.c between commit 63afbe7a0ac1 ("kvm: arm64: vgic: fix
hyp panic with 64k pages on juno platform") from Linus' tree and commit
8f186d522c69 ("KVM: ARM: vgic: split GICv2 backend from the main vgic
code") and others from the kvm-arm tree.

I fixed it up (the latter extensively rewrites the function, so I just
used that) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/m7KGpMGMqLmZz4zkVy7oExR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT2eJyAAoJEMDTa8Ir7ZwVvG8QAJXlbnvzgGiBMPDRgzbeuOvl
IsZTZdmjtyOiXl35zNfd5gGr1c3iHBTfkxwgCvjo4YyGphhmkShWEOqvwrqsMPzt
BENzU2Z8QjnlhroJlF+wLzCUFGoWVwyZvmi0/e6TL2tKvFzKTeq2urjzCuyE6IfN
bOzBmE77WgLvlVfHSmC/mhhpu5MaCPapRbXzqOgMbmQJxCCMlfpJjjToU+PSstsI
s6L/1kNxvSAM6789apXFMF28ZoghuoOXoXAKtP4g/8KZl95tnIPfvVATBQP0QpUm
m/7KPeYT7ZUXdyo+KSuCEeDqx9lQnajv02haMedo7x3nEGBIOLDKUBkg1fVswsiY
rstC1KPfbfE6G3dhODdpvdg0pNS4FXiBB1conk4D9hx46Vxkc39FkXtsZ5IHNuXx
BM2UpK3tG6GNtMweGsnvinzAZe99CUHHOHzb7artZM8hKQNOlQMoTwivnWkLjqSo
1W71ZiaN9pPjQkj/CzFAJ7+RjHYwUe3vN2KjRd3SAb0//FUkmLi1z4P+SgJO8J6X
4TYtEKtyqywvJpOHb8YF72H23yF2Bm0M3vW713v/K5HoD3wIlY0ReDAeJ5DB0OdG
4mvnarIqCD6CY4SdIFL7ooCkWWOzyhqnm/wbKYhlINjkM9OvcmKHsTO2hGbepjD2
lNph/Kfb68Vm8jf/gq55
=v2S1
-----END PGP SIGNATURE-----

--Sig_/m7KGpMGMqLmZz4zkVy7oExR--
