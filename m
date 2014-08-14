Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaHNXz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 19:55:56 -0400
Received: from ozlabs.org ([103.22.144.67]:35135 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaHNXzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 19:55:55 -0400
Date: Fri, 15 Aug 2014 09:55:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Johan Hedberg <johan.hedberg@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-08-14
Message-ID: <20140815095547.75d9e9d4@canb.auug.org.au>
In-Reply-To: <20140814145000.GA14226@t440s.P-661HNU-F1>
References: <20140814145000.GA14226@t440s.P-661HNU-F1>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/BizOQNKk7dPO++rI1T/Yfet"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/BizOQNKk7dPO++rI1T/Yfet
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Johan,

On Thu, 14 Aug 2014 17:50:00 +0300 Johan Hedberg <johan.hedberg@gmail.com> =
wrote:
>
> Here's our first bluetooth-next pull request for the 3.18 kernel. Our
> tree is based on net-next so you'd need to pull from there first before
> pulling from our tree.

This is in a branch that will be included in linux-next today.  I guess
you didn't read my (very often) repeated request that no v3.18 material
be included until after v3.17-rc1 is released ... Please do not do that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/BizOQNKk7dPO++rI1T/Yfet
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT7UyIAAoJEMDTa8Ir7ZwVjpYP/1TKmiRpxHutHSX8MRuieAZf
l9EsZg0ikPdOJft0kSqzCTdw6uNBnNkMCkkHC1oAMwjWJ39oJ/CvNwjj1lqEfd6F
C4TgF60+1PoKR8iK5Nz8Gf/KvPPJGjEhzAJzTVRL2hgMP4YiWsCegwYpzuq/TibZ
ZzMIw23U5Neg2aseOBw6jWvPGGKx2Z68Zma/rF6IUHCq4A30gBMk6EfXPyWPTKrW
kLI97mqKnu+lUF/O4UYB8mewkzVm5ktxeAH5zNYQEo8hYF2p4WkMmM4rf+680vI4
JZ3vFMIYVkOTN5idTw859IhitQimRFR9zu0uZdhwm3jrnx5OADhc8a+P3D3ORv8J
iCRQXtZ+sr30FwMQxGSwsTi3tFKBoyKHZNBc8BdACA5uFyEGnXCx9f1tMTnNsLJo
Z9qauI5tLzblsCNVv93xZaFELnuAs9u0aSVU+FDbnMGvjJUkS/uNTRhLoxDc8mLF
d6+E0/tz07SB19rNwSm8j3J/nmhpO5DvUoHO7iccKEsOrHDnbc/dkylEhky2vLKO
g+m/Ap6k+FXpYBm91QPHfrDejpXLORIkkTqW3m5sXksPjQhZZfCntSuTD4D2lqjr
muEzg/HJSh3M9BwvB3qpGgxtgOT2V+x85JTPR5mYGGOYD7GoIi4CiYs99GAw4NNS
5sW1qNXHoxgnv62ryX+V
=Fr+3
-----END PGP SIGNATURE-----

--Sig_/BizOQNKk7dPO++rI1T/Yfet--
