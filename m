Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab3H3HAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 03:00:21 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51049 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab3H3HAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 03:00:18 -0400
Date: Fri, 30 Aug 2013 17:00:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Graf <agraf@suse.de>
Subject: linux-next: manual merge of the dma-mapping tree with the kvm-ppc
 tree
Message-Id: <20130830170007.5ea2e4bba8b3edeb1633517e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__30_Aug_2013_17_00_07_+1000_fA4OxBcv2yKa9MXr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Aug_2013_17_00_07_+1000_fA4OxBcv2yKa9MXr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the dma-mapping tree got a conflict in
mm/Kconfig between commit bf550fc93d98 ("Merge remote-tracking branch
'origin/next' into kvm-ppc-next") from the kvm-ppc tree and commit
f7d8f1e9cb44 ("Merge remote-tracking branch
'dma-public/for-v3.12-cma-dma' into for-next") from the dma-mapping tree.

I fixed it up (these two merges resolved the conflict different ways, I
just arbitrarily picked the kvm-ppc tree version) and can carry the fix
as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__30_Aug_2013_17_00_07_+1000_fA4OxBcv2yKa9MXr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSIEL7AAoJEECxmPOUX5FEPn8QAIvahCmDXurtMyG5kJ21X5+o
vI8myhWQ+DR9+r+BEqQO4TePaSRlB34mz9EuOvxGJmZjgP4TVZHv4XHPr4UppukC
UiEF+aOrisZhZ1sXVhdHYeQC/FJPEZn1UEHemiD34pqqzNBtech9FN1utYtzZpBL
5mXlSlr/RbSleLtYJEHn6UYEGi4SfvOKIFHO4zSrf1OLaTxMBqqw1WBMEkAH3S1q
RvfwGvdGbzmpZciQvl0bW8cGE3oasPIcWdK9WTcDhit96r1HbwiGEhFohGm/99Kn
FAnSOQowUWYFU9SUSDWsBTUf3jfvsDJl9eZfHXkJoPAEr/nW5pQWjuviu00Jyvby
ppFOMv4NFSH5LxrGv1/gCc1EblVlBNOuyXmZUeshfenppaE/sWj9Zlxz3OslcqRR
Ii/YGAe9hvgm7DFZsaOmB5PiC/QTQrvBGf6Z0rqCnm77q58ZT9F7Ue/G7i9DbPSb
kIq/psNKfviN1wH4eCc87/l+VQP3RBgGas2YWUYDN0psd+/PCoXPnpZFbuJji3w8
HbZyS85HdhZzY/yxk28IeEgF8IYHIOcg2K8SXBXzcNjlHr8iW/isRgW3GN6gSY4E
BGKojN6tqqRTH3YKubY6TXsXTLSk0E8hs1JdvE19c9/EZmyO2bXpjJq3u6qqFMAz
WB7vIqnOmtot0r9u0Tbm
=Czeg
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Aug_2013_17_00_07_+1000_fA4OxBcv2yKa9MXr--
