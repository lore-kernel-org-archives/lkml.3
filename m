Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbaIIFgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 01:36:46 -0400
Received: from ozlabs.org ([103.22.144.67]:39316 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350AbaIIFgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 01:36:45 -0400
Date: Tue, 9 Sep 2014 15:36:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: linux-next: manual merge of the userns tree with the nfs tree
Message-ID: <20140909153638.6c10fc0b@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/I32VTzT+WIgZiPwIB6SOX6s"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/I32VTzT+WIgZiPwIB6SOX6s
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the userns tree got a conflict in
fs/nfs/client.c between commit 21e81002f978 ("nfs: fix kernel warning
when removing proc entry") from the nfs tree and commit a1998908ba46
("nfs: fix kernel warning when removing proc entry") from the userns
tree.  Slightly different version of the same fix.

I fixed it up (I used the version from the nfs tree) and can carry the
fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/I32VTzT+WIgZiPwIB6SOX6s
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDpHrAAoJEMDTa8Ir7ZwVz5UP/jv8S9HZxzksjirVXQ3yldLr
esCbkAbosMcHvBc9i+IyJ7BXyv59QdppHNnnD31aabBBiS0daQtk24W18PLIIYXs
Tv1GYIKrx+LmiVF9eCc8+SWYY2STWqN8LbEf0UOrzD0mZvAD3JEk5h3z406+BVM+
wf6WkT3dd7MFlCSfIMV+zacCidIEWUK9FV6xRr62MIwCXlli7PJ240pes4v+Eo4E
p1JxR40aclQaos+O7E6WUxlx+sr1e3Yqm4YSHjNPOSKkIKmFWmSZI676XX9kdh2d
w6GMpaYGrhr5lYmDtIHlw0avAr4YYY2KuQmxpRGWLGx0yPApJnzANeXLLQ6LH0Em
493c6dcibr4URX948anjJ8BR3l4Fco0RG2F34oO2qEFnOWIMAJfE8cLPBWxAfPo6
ghIB8YYYJV/JXK0n6DiQJl5PiKDDiiq/nDw81rn37xpkE9+3dG9zsNVXYS/g0eSn
swGA55jnItiGnTbkqlcucNwtapBgmXTcVbwI3/sjohqQDpPsmMPkc77D3hPg++ey
VmnpXdyr9wcw1G0hnU+hjkbIfD4tiN8iomWud2ZN7cOPMMUPDWb5vxEweuACbpf4
tx4dlbEF1A+lxVwCY8FwYzRZ+AJAEeMYaPAiB3HxNTPouwPp2hY/E8HNIC/qIQm+
oHkhrv3Eb6TQj+24gENJ
=jZhF
-----END PGP SIGNATURE-----

--Sig_/I32VTzT+WIgZiPwIB6SOX6s--
