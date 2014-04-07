Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbaDGVrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 17:47:43 -0400
Received: from ozlabs.org ([203.10.76.45]:57829 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169AbaDGVrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 17:47:42 -0400
Date: Tue, 8 Apr 2014 07:47:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: strange state of the kbuild tree
Message-Id: <20140408074734.34deb43270183941b5118c7f@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_Apr_2014_07_47_34_+1000_JUp86DQBCiwuoT7C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Apr_2014_07_47_34_+1000_JUp86DQBCiwuoT7C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

I noticed that you have two copies of two commits in your tree ("Kbuild,
lto: Set TMPDIR for LTO v4" and "Kbuild, lto: Add Link Time Optimization
support v3").  I understan why you recommitted them (to add your
Signed-off-by), but to leave the unsigned commits in there sort of
defeats the purpose.  This is probably a case where you should have
removed the original merge (or just these two commits) and then merged
the new version.

I am not sure what you intend to send to Linus, but this whole tree (in
one piece) should not be it.  From the state of the tree, it looks like
you send your separate topic branches (or a new merge of them) which
should be ok, but please after doing that, clean up your for-next branch
(it current has merge commits dating back to May, 2103 in it).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__8_Apr_2014_07_47_34_+1000_JUp86DQBCiwuoT7C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTQxz6AAoJEMDTa8Ir7ZwVNMIP/38ZvUkBlhNotAfhqt1DtWOP
o4dBI15g1wnse69phAcuqY4PZir3DFfWCkeFifsxxWHsEj/oEeZYbk3cDAKo0DAs
RSwcrdaOZHy6sJh8g7Fye5FU3qK1yxBZBqIWwcEUu/jkzoNcWx0c/OdWWgj1pGSJ
gPvAOJAka5EbkDPxP7I0cjLJBM8Fegp/1z/aBTuBcxY02vXM11w7SA1bh8OmGz0q
JBjWcyPZzzc4kHi2nxHG8ZW7Cse2HhCjs1uTcZMFVVdnK+6BKK3OmutoKzAfgym0
WEtVpXQE4JF/SP4f1ITnoFEGqu0qAdpiWKd8LhZdW9yBgP0KhByouKz3AOf7CoB/
XFlAUvnunJI4arOGOCFFvWVZmvW6l6dV44Q3Wdha41sFOS0w+/sB4BKtUeCLza3V
Q9PnXYyVb782rIUqsCIvE1bgh7SJkDLU09TXD3xR1+nMNqeCVlwiCJCKEauM1vjs
CZbpQQqZI71i6bSOrinONCxz3g073Q9azVoFbVl+Ockx7EthGTF27FWDiv1yoAgv
F3ksilTGyHDDfUvDkbc6iT7jyvz5h3AKUzOnP/KwoKdYnV1SA2gYmRNKRa44OvR5
iztvUH54gn1jO6OpnFbLXiKsUSqn003vhC/NP8pDR53AiKwnwZwX1cm1SKTfOm+J
ZIxO7nRrTpz+bqvBdVIN
=nCkT
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Apr_2014_07_47_34_+1000_JUp86DQBCiwuoT7C--
