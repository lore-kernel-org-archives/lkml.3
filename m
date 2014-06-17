Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966723AbaFQWtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:49:36 -0400
Received: from ozlabs.org ([103.22.144.67]:35333 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965537AbaFQWtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:49:33 -0400
Date: Wed, 18 Jun 2014 08:49:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: the cgroup tree has an unnecessary merge
Message-ID: <20140618084921.07c3b391@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ABg9P+6gYD0JuDacTjLrBia"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ABg9P+6gYD0JuDacTjLrBia
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

The cgroup tree has a merge of 963649d735c8 and c731ae1d0f02 both of
which are already merged into v3.16-rc1.  Why did you just not use
v3.16-rc1 itself (or the point where Linus merged your tree) (and then
add the other commit on top?  That would have removed any chance that
you resolved the merged differently to how it was resolved in Linus'
tree (I don't know if there is a difference, but I have had conflicts
from different merge resolutions in the past).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/ABg9P+6gYD0JuDacTjLrBia
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJToMX7AAoJEMDTa8Ir7ZwVZy8QAI9Q+WGFT4lfguPftwK1J/c6
fq3RjC81hEjhheo3+tqoonASO5ySifCH/TH2Ow90ono4mvPh6jT3GrQPpPTvp3lZ
F1DliAIdHh37RumNes2ECTyiXv+mOaQ4bl+Oo6W9zA/ni5+rvvCE+G5Z9QcDBFzH
jZ2SRSJpU28JMDI16HW56kzAsROYBmf+nNcdTt7LDv3lUvquAhPqAcYG6PC9ltyS
JZjjL1zXfWNRMIorXsdCtodONRiFJ9HCC/VLT9W7Lt/B7Q44oTXjqAj/5vGBhlyL
ZQYV+dzS7RWMyuFZRWcRR5BNQU5Tbk8WWCX9OR9ye1CYk+rcOzh8kNHmvEsi1/fT
HGLeTmJtYgBz+YB13IbY1jHHBtnY4Q+aQpjf5sZ62R7JufJQt4zo54CC9a5e9pUd
snovff7xuqrR3QBIeQ6bwtoqX0v4CSTkQbiEQdow5yZF9TlX/ujYDd6MmYK/zdYu
XUFpRPb5RNGzI36HiEWolMcynNS3SLIYYaXDANXFUBt0v5qUtZgj7KfKyLDJ2Tlg
MNtOoIWbwKmj/9hh2D1GK3qT/Oo4Cu/4WU6Au7bOzSnzmNDNOCyDK/4TxlGrEF2t
oxc3DKF9v8QMlc2iNbDAXRchULmoJooCDLNBoS0GHbCmijRQfitAP4YqDEXW7vQM
bu16ndceE3grPn5snwy/
=ySI5
-----END PGP SIGNATURE-----

--Sig_/ABg9P+6gYD0JuDacTjLrBia--
