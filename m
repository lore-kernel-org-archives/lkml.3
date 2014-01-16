Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaAPGgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 01:36:51 -0500
Received: from ozlabs.org ([203.10.76.45]:52315 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaAPGgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 01:36:49 -0500
Date: Thu, 16 Jan 2014 17:36:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Subject: linux-next: build warning after merge of the final tree
 (akpm-current related)
Message-Id: <20140116173638.5a1f01f8efb8cb7d48e021b0@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__16_Jan_2014_17_36_38_+1100_efx=WySKsEjdsKb8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Jan_2014_17_36_38_+1100_efx=WySKsEjdsKb8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (arm defconfig)
produced this warning:

mm/nobootmem.c: In function 'free_low_memory_core_early':
mm/nobootmem.c:119:26: warning: unused variable 'size' [-Wunused-variable]

Introduced by commit dd3ff251123c ("mm/nobootmem: free_all_bootmem
again") from the akpm-current tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__16_Jan_2014_17_36_38_+1100_efx=WySKsEjdsKb8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS1339AAoJEMDTa8Ir7ZwVqrYP/iVGSH/RgxuI7thKqHeFVF6I
SyYytKT7HbPWSm47CFIW08wrfMwMF7q62Cpj63IlWGwx3KTBIFoVlej5YbP87g9U
YsLGQF3IdwqJ8MQdVeVuX3VUFf1Z1tpRlg4dnnIKjDwT7nJS/2VxHsp2dYAFLaEt
45w1nojVzIZRTcEGBu8jUf6j8lguJVsVhXMRhkdRfPxfYzLTnrDFODdrK7aaRjtp
T3jK3jAhqSK8l9n8OK4woS+lHzvW4mrqInRq9veF7YrVmiEaVnOHaGZQyoDKGdPZ
j+HhVSqIJVBK2JKysx24CIvkDkiUeiIDrgx+r9N+vNdgm39rjTnilgkZ48eSX4I8
H60vK06EzMYdTX+497BPL6vRZPjO+kN+hdoN4BZ0JnUUWnT55Hd+djqZW9kOJpuS
J+VcZiHS/MIKUD3FalrfDJHhCBPux+m6b5GHFkkwh5c8UFYf4YoxGxW7P6dNxQUu
eyxKiG7dkKdkdplwdEmbd55Q8Ee2kKMp+PXvMR86wEglkCsrfPU5rciZvqYrjd3+
dTymSKTm4uL802W19Zxb/8A8DwI5QzxVdo/FWrqiNpFU6o1k6EbmpfZn/yEDZC8l
ASB7qhxtnbOabnHggaPa4eRdzKDWpkdIO2aoAiAy0BBb1SqolYUWp7C/Qqc7Mxv+
cKU9pp/+1HR5xfmC8IZa
=1xbB
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Jan_2014_17_36_38_+1100_efx=WySKsEjdsKb8--
