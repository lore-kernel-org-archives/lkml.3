Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbaLHH24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 02:28:56 -0500
Received: from ozlabs.org ([103.22.144.67]:42216 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbaLHH2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 02:28:55 -0500
Date: Mon, 8 Dec 2014 18:28:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pranith Kumar <bobby.prani@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: linux-next: manual merge of the kvm tree with the rcu tree
Message-ID: <20141208182848.176cabf3@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/tJP2X1pi2MFHvMsX8zO3Zf_"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/tJP2X1pi2MFHvMsX8zO3Zf_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in
arch/ia64/kvm/Kconfig between commit d80bd9c0e85f ("tinification: Make
SRCU optional by using CONFIG_SRCU") from the rcu tree and commit
003f7de62589 ("KVM: ia64: remove") from the kvm tree.

I fixed it up (I just removed the file) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/tJP2X1pi2MFHvMsX8zO3Zf_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUhVM0AAoJEMDTa8Ir7ZwVHxgP/RrpBx9IBg+e8LyypE9B2Ioj
rq199yxl7pAeNr+cFry/5D1wXoQfSxAQG+MWdOF8xsnnWBpr1ZLjzIDhPAQABGha
Rg/SUOvCCJ1OSqCUS1jDmzdOIjWTln8OR0oKmo9RL+teifna8AFFXHziiI2HA4iA
+lIe9fN29/UIYjo3qh4ms9hJgZpR/qZWXFeHjC6lMky214lOVTK7++Rgr/SudIkE
RBqJfa1J/8mNlXRkgMfDOFd7CEvR/4+Ts2Eg3KMQl0acu1eHUzbSSSMK1BIapN12
uxA9AzexuQHA0lpwiQOi1ufU74gUve4+VqWyVEIYyfskm7JiLTGLI1IaYFJoyVwn
C6YJIBauf6GUP8sAI3yxsIfNjyJknvXeMSlYTNLyDDWTZj3PIRVHENclYN2ILFRx
jXw3ZyHPJXXhtxuebYjVMCjpEiY1A3nUi0TXlLHYexV8xyM4IO8H9N8f4wHGUm6H
gSELzO9GBGHy+2RtHHBfEb6I/hpkMHKgxmhRibwUsD/CM2O6k6qN6gXnd+S6paeu
1IWOjs1bWynlyXG/0ztyvxD6YnrC2YkfvL7B4FfJa2QoVPl4G3KW9XfxhVyBw1Ig
UWK7381WDM89I9QX44UNYSqhqCKc6sixubUfZjHN7yCv9eTq3yHr4r7Rv6nTLhX2
wLQ63H9hjAtzT+GMzutD
=X5NT
-----END PGP SIGNATURE-----

--Sig_/tJP2X1pi2MFHvMsX8zO3Zf_--
