Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbaGIDyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 23:54:08 -0400
Received: from ozlabs.org ([103.22.144.67]:42643 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaGIDyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 23:54:06 -0400
Date: Wed, 9 Jul 2014 13:53:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, therbert@google.com
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20140709135354.0011c63e@canb.auug.org.au>
In-Reply-To: <20140708.204751.1058890009924915825.davem@davemloft.net>
References: <20140709132619.19eb3f6a@canb.auug.org.au>
	<20140708.204751.1058890009924915825.davem@davemloft.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/khaW.s5qVeWWitxu4HpdL9+"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/khaW.s5qVeWWitxu4HpdL9+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi David,

On Tue, 08 Jul 2014 20:47:51 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 9 Jul 2014 13:26:19 +1000
>=20
> > After merging the net-next tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
>=20
> This got fixed 5 minutes ago.

Thanks, I guess that will be picked up tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/khaW.s5qVeWWitxu4HpdL9+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTvLzbAAoJEMDTa8Ir7ZwVvhsP+wfoxRn8ASsPuqsKP6EWD8Wv
HmfzrCpVYp6nK4uebd0kaqCxGA8LDoNUXzUgumhS5EPdq5g5wUh2S0x41WJPVBo/
woE4wkxqXct1Zv1JlYCapZzCSGoQPXIZGDjeE0wvaIhWOuDuKp5fNcaBtiXLy1Gr
MGo4aN4ERA7FddUOTGZEctP2Mec8LMraVb6FpHEqpbYcv3LCfppLFJnutl6ENPSw
8pz3fSDZGsrphk4qBulVmSmOaXz2sQtwP0VzQTYviQ2G0BewFQQ/og3z46jCTUtO
M1HEVdaAUNO3k7UWYfiBk/y8F8SB+P59NAVJBLwhy088KkTe6BvuHJpjbhtGSvtZ
EC0ZXaQrLhai1RMoTZnfSSVO55Jx1fchc/ZZm6/qT8rzRXCBFEcJC8rwGJB8CnNR
bVfMoNgNDMu0ICn4tTgUS669l8uklPZAuLoVUIYc0bzg9ManpEWqXWQkRXg1f3jw
hseAlAm0rtZqNkMYyCEaYJqNsyK1/a6cQtXDPD64es2Lvh5+je43qm4TRnmwFJ7f
3jCdVy+UviYeMeQpR1Boomkr9C+UQMFujJqp6KKFsKvRh/A+uFa7rxiU8Do2hmmb
YA843MG+Hz8cdDJKVjhZv25gZ578OGK1sJ83iTUKl2GFxHtmLDzVUHpnVYlS8G62
FEb1V0n6qTXx7LM3nn2z
=kWJh
-----END PGP SIGNATURE-----

--Sig_/khaW.s5qVeWWitxu4HpdL9+--
