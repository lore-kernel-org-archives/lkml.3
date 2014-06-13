Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaFMF2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 01:28:55 -0400
Received: from ozlabs.org ([103.22.144.67]:38434 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaFMF2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 01:28:53 -0400
Date: Fri, 13 Jun 2014 15:28:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140613152846.3c9bd9b1@canb.auug.org.au>
In-Reply-To: <20140613150550.7b2e2c4c@canb.auug.org.au>
References: <20140613150550.7b2e2c4c@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/NkonlRImtHtsobQhaAuANvu"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/NkonlRImtHtsobQhaAuANvu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Jun 2014 15:05:50 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> The reference to HPAGE_PMD_SIZE (which contains a BUILD_BUG() when
> CONFIG_TRANSPARENT_HUGEPAGE is not defined) used to be protected by a
> call to pmd_trans_huge_lock() (a static inline function that was
> contact 0 when CONFIG_TRANSPARENT_HUGEPAGE is not defined) so gcc did
  ^^^^^^^
constant

> not see the reference and the BUG_ON.  That protection has been
> removed ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/NkonlRImtHtsobQhaAuANvu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAEBCAAGBQJTmowTAAoJEMDTa8Ir7ZwVNnAP9i5uNY5HsBloZYKbMRXqe5ez
Vi+um2oNC9tCJ32wand4TBpJDKxP6nGPQXy9zSLEsXBPFLUeOlrbkDF15GhZZoF5
/sDus7GQyntHcnKmIDtrdpqNu9pco3JqossX0lUT7+Ci4U2NCopmjV14hCiI+zA+
GYQhogx84z/fW7M9kcWfpUFr6P6OTOdk68GZS6zJZYIDCywVT9RrFx5yexy/TRIL
8KUao3cIt5nW4iy08u7f/DoFfaniZS9PxcJM5vsF3WUQs2FcO136SWxgRtlv7kRH
NWEO+zA07Y9lSxKlcpm1Rh1KNlYG6MbIHp0l5qtpCIjjxFfrDB8qSOVD1RC2KuA8
RDwxNL/cKn2MyzuVVlL/hZuwGdZsUEAwfgpPOiJtblJcwIjmzLnbHr7gFznPNIW8
hWMbia/jOjqN6W8RHs7OZtH0+e4WWiSTx2+emyr22M8BS48/6lXRVRjfz7aZ+XoI
/fxc3ZFoJIY/SabQ6eK1wOcez9OuiihWW71OwV+jz2nrTiAkiQ/4zvIBZrA1jz8E
9jMMSLrBt0RlpMIGa3In6uqWv8EiIJQV8uEKFiDUSIr5ol54kjLvooeYAk6vGEQO
vjQeixucAyUH1uINfUCcZxUBwaQJBuBJKeKO6U2GI1sMlofrmDPf9EoUpHFhralI
1OqHN180fzNsrcyGBtc=
=wuU6
-----END PGP SIGNATURE-----

--Sig_/NkonlRImtHtsobQhaAuANvu--
