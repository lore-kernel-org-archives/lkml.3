Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab3H0DFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 23:05:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34202 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3H0DFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 23:05:17 -0400
Date: Tue, 27 Aug 2013 13:05:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Munsie <imunsie@au1.ibm.com>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: manual merge of the pm tree with the powerpc tree
Message-Id: <20130827130507.27bd4ceda462db1751bfc30d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Aug_2013_13_05_07_+1000_=PZhilQHd=xvTHH+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Aug_2013_13_05_07_+1000_=PZhilQHd=xvTHH+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got a conflict in
arch/powerpc/kernel/prom.c between commit dc0e643afc50 ("powerpc: Make
prom.c device tree accesses endian safe") from the powerpc tree and
commits 819d596568d8 ("powerpc: refactor of_get_cpu_node to support other
architectures") and 183912d352a2 ("of: move of_get_cpu_node
implementation to DT core library") from the pm tree.

I think that the latter superceded the conflicting fixes in the former,
so I just used the latter and can carry the fix as necessary (no action
is required).

P.S. Rafael, I used both your addresses because I have had a bounce from
the sisk.pl one in the past ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__27_Aug_2013_13_05_07_+1000_=PZhilQHd=xvTHH+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHBdnAAoJEECxmPOUX5FEPyUP/iZE8GL5yG0uUsWBUzM0PFtF
3ua5VbUd/Anzakk+gOjswUtbC/BhdTluHwLuEEi2oKzj6XqHA1NfNVT8k+o13shl
/lOZzDEcxqFpkbItJrsMDW9n5eRBw2TebAbqa03Hx9fDvBuZkTQVS1QWpHuggu1D
tN1wr4ktpMM9odR/jYzN12WHYO7Lk3AADvpNkVU0/VUuBRpKCzwvN3DRi0XJ6jp8
QNXRgrYj9b+ESdpFY/4Hg+4wk7CLb6rxgH+85RfgAynv5zie/GVTA13wksvI9WLm
Zk1ZQRGuz8Tt8qAs3enLiunOnsbF/W41SQkjB7/gLYCzqwF65mFUIRKZz1IBAKuf
aJSi/GFe3qwg8DDXQxlnQ9DyNYWbl6Wf12F5Au5E6Cw6yhvNPdHd3Z9m+gRFs1nx
O0Q48xVWVuq6RFpJ0rxUuzjaWF4EQRCLXX20iQZ0Kjd3BCWGdnVc3Pxh8TmdoSwF
a1O4nGGp6/06xkUptzJ4dpHGvKzDDfjkPdJui2WoilcW4fknSQtXKvy40oGWRQQM
/PUb2vpUJeg/UPEw+v3+7BOrcGvPq2w8y6xs8Qxg9BuvFLm+ofnPt7lLlgn9Gijy
9S0+ReZKN4nRpTYzN1tFh27oM1RbQWGIta87PSUrxgV6qJqWhG9vRDTdaKgxHk6b
ZDrOB0nPC9PAzIGkr8kM
=3JKn
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Aug_2013_13_05_07_+1000_=PZhilQHd=xvTHH+--
