Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaKZGTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 01:19:24 -0500
Received: from ozlabs.org ([103.22.144.67]:56992 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbaKZGTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 01:19:23 -0500
Date: Wed, 26 Nov 2014 17:19:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20141126171914.19ad9151@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/yZipVHhD6SLAjK3Y6qYdkAK"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/yZipVHhD6SLAjK3Y6qYdkAK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in
arch/ia64/kvm/kvm-ia64.c between commit 003f7de62589 ("KVM: ia64:
remove") from the kvm tree and commit bf4bea8e9a90 ("kvm: fix
kvm_is_mmio_pfn() and rename to kvm_is_reserved_pfn()") from the
kvm-arm tree.

I fixed it up (the former removed the file, so I did that) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/yZipVHhD6SLAjK3Y6qYdkAK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUdXDnAAoJEMDTa8Ir7ZwV4mkP/3qHjvJfrAoFyXay+QYyiAi2
h0A9t/BJeEsJZKs/BsmMybbXk/5AtgeFddjb04juMqYnptq73HSZvyg7M40gxct3
kr/wpDCEryMsI9MHw8JUqo3uWX56958LO2fs5GVeK8Yb16DPzUU+ZbxTNU0idycc
+LcvrkAAyGOUsRWkl7wtWkou/Ct8X6EMeR4t8cZ50Z7klxZBPHcXMoXImnNE11s9
YIwQIYHVqgeJ9hxFZLDWNXclsN96EJq/0+NPJVrKF6qGzTHB24UlAjg7CyMSDVGG
mnVYB4bwj3GUJfzs3NjQpyFK0S1ReM0XW3t0A7Z9jdIHLRMuvz/r9hdDoB6QLBcu
tA46iZGCu/VX4joWjfmA9XOuExbbEthhlcOyHplD2+l1fmvAn03PACWv0BsYWy/Y
eQHzjRz3L5UqES+1k0Pn3afNyzLLBQgM2YxHjsVVWSYSL3lOdyCKv1+ByyWtmASd
B/dYIm6o3+NG0s/zfccj5LkY/F8Nhal2tM819Ql4AcleWpW/x232wkcx9es7EsBw
q7IP04+OScQ4zvhWlq0VwkSbSBhEj8+chsf5u3adYfYTmBBkDXfjhIv1vZtGZ0zT
OvPZHY5LaCRRNBdWvFu8NH9ISUwPxP1bOp6MdV6Ammw8LdVctFM/Yn6DMYHvkIeH
/2GXhhU1pnBR/vtg+ODo
=/c+B
-----END PGP SIGNATURE-----

--Sig_/yZipVHhD6SLAjK3Y6qYdkAK--
