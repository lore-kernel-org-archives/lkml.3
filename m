Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaAQDOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 22:14:30 -0500
Received: from ozlabs.org ([203.10.76.45]:55725 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbaAQDO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 22:14:27 -0500
Date: Fri, 17 Jan 2014 14:14:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: linux-next: manual merge of the devicetree tree with the arm-soc
 tree
Message-Id: <20140117141420.e70ad2837f74fcff6a7f4a9d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Jan_2014_14_14_20_+1100_R8z15SsjuF0NcqTE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Jan_2014_14_14_20_+1100_R8z15SsjuF0NcqTE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the devicetree tree got a conflict in
arch/arm/boot/dts/orion5x-lacie-ethernet-disk-mini-v2.dts between commit
6b6430e82331 ("ARM: orion5x: Fix typo in device_type property of phy
node") from the arm-soc tree and commit 40aad3c1a9b6 ("dt/bindings:
Remove all references to device_type "ethernet-phy"") from the devicetree
tree.

I fixed it up (removed the line) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__17_Jan_2014_14_14_20_+1100_R8z15SsjuF0NcqTE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS2KAQAAoJEMDTa8Ir7ZwV9x0P+gPjVFl7jRAjBlyNVFX8yqT+
ABjAoooGL1NjXmlbAW1hPOCVGnv1qLdrt+q0z1Rnnz7HkqUvTXoCw33MnGJQsLGW
+rdhoK8WkUNZa0Ts7EyecBBOzi1zX44OJoijcwFXZ0dQ6zJfIq/PuL/KB568jpO4
YNhMSXEPh/DtG4ODqkfPRuob35x6h4v29AA7VJdI1sW1KfB2zQjPXfglsEzzOmkq
0jWoruG14bq8q8kKgMkrX2ClYUo4G90GTzoXb3BSZv8i0qfpL+Q6W8rjy1wsuCMP
h61IoRDBiXw4KgnRUwFljaZeKUHLIoWnOyx7VxtObzpifKiMY7S3A58j8HpUGyQW
iXQcH8pVsYxVNhs1M5sGyTutsGe5Kzg1CzoArhohlsTrKDbjfc2hjxi/gDYp2SwZ
BH+OYVxGT4xqSC7RUFTxYS9SgrJfQDdh1yJfDAcFRuBzHLGxsle0uDFyuDcbJVtR
kJvgDgcD6m4w/TpRygseg2QgprtMftXkELdvzBytRESnnqOtb3hIc54KRfIoqZRD
53rttC+uq9C9iAyeHc5Aw+SeBOUKB4tDFPA9sFvyoJCt8AInYCEG5O+o5q81dC3L
uelpZtPQbE8pf+JT1Owyie71h1Nn37N7OdzFx0JeLZbcF3SChM5CWJqu3uBAOFFq
3kFNhiBsFrQEgJrOFHr7
=vIMy
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Jan_2014_14_14_20_+1100_R8z15SsjuF0NcqTE--
