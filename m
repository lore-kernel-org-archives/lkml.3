Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbaJQBrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 21:47:39 -0400
Received: from ozlabs.org ([103.22.144.67]:42941 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbaJQBri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 21:47:38 -0400
Date: Fri, 17 Oct 2014 12:47:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the kvm-arm tree with Linus' tree
Message-ID: <20141017124730.6df8beb3@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/=WTJO1K3l0bG=pSNQaqcEp2"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=WTJO1K3l0bG=pSNQaqcEp2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in
virt/kvm/arm/vgic-v2.c between commit 1f2bb4acc125 ("arm/arm64: KVM:
Fix unaligned access bug on gicv2 access") from Linus' tree and commit
2df36a5dd679 ("arm/arm64: KVM: Fix BE accesses to GICv2 EISR and ELRSR
regs") from the kvm-arm tree.

I fixed it up (since I don't know any better, I just used the kvm-arm
tree version) and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/=WTJO1K3l0bG=pSNQaqcEp2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUQHU3AAoJEMDTa8Ir7ZwVYtwQAIHmDgFKXNwazRTGec3T6zU3
ICpQi8Uuc7jHnYw0jMm55/Z1D1O6YOxsekluI9prkf7AAezxHO8wkArsUbHNMk2P
qtE6WtvcylS8IJO+UUEToPXczxLzIbU0zcGNkJOyCvlG/qBrUw/JiX2vcvx5k6wf
lgg3fL0Ivkk7Bss0JAG3+esuLwJKNnq47SEL5/RbTFjCGB0GTNNbV0Dl/QnSoVCh
4JDLszDyHj75jfC7B2jB+Qdw9jIUSM4X1HqHY+eiTLQiQ3i8KK2XtePeV3WYr7QQ
zD4H0kZSvLgfUhdrXRkJ7scp4ZvdFNHPZJvzgZtcz/UzV2AmFATlDpWn+wCm/yjH
4y3KYauXNiRyemkJ+6R4WrePHrdHJ8/Hdscga6B2T3sKwVLjZaoUM04ceFVASuyY
8540q90OxuVI7J9mYws/daGhRUck9yFBLUI9qot5gACu1gSdYF6mU4+kN1QfNyeJ
N7pWVfnbl6RhoO8LxlhgkdfEL8+bKs0nLDKIVzdvpxQuFLnlMVO6LhvBPsTu3u+l
l8c36uj8N6aT1liNa3MLjErZtrsMyULMK37hhbDK7FcncBW0xL858hIAc2HEkw/d
/V+mjI8/0/brsIXHG9PZ0PPvMKuqsjDqQcut2VKVkPVDYY8oc5FZ7lV6ST5cM6H2
xUYBAHAUnFoB4F5PNRZM
=jDQQ
-----END PGP SIGNATURE-----

--Sig_/=WTJO1K3l0bG=pSNQaqcEp2--
