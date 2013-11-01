Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab3KAUXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 16:23:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60623 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3KAUXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 16:23:06 -0400
Date: Sat, 2 Nov 2013 07:22:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>, Dave Kleikamp <dave.kleikamp@oracle.com>,
        Kent Overstreet <kmo@daterainc.com>
Subject: Re: linux-next: manual merge of the block tree with the  tree
Message-Id: <20131102072252.88d2380fa392705b912dbfad@canb.auug.org.au>
In-Reply-To: <5273C473.5070803@kernel.dk>
References: <20131101142026.10390b6e3f70de348770c137@canb.auug.org.au>
	<5273C473.5070803@kernel.dk>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__2_Nov_2013_07_22_52_+1100_d2+_P.ARWbIEpCCt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Nov_2013_07_22_52_+1100_d2+_P.ARWbIEpCCt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Fri, 01 Nov 2013 09:10:43 -0600 Jens Axboe <axboe@kernel.dk> wrote:
>
> On 10/31/2013 09:20 PM, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the block tree got a conflict in
> > drivers/block/loop.c between commit 2486740b52fd ("loop: use aio to
> > perform io on the underlying file") from the aio-direct tree and commit
> > ed2d2f9a8265 ("block: Abstract out bvec iterator") from the block tree.
> >=20
> > I fixed it up (I think - see below - I have also attached the final
> > resulting file) and can carry the fix as necessary (no action is
> > required).
> >=20
>=20
> What tree is this from? It'd be a lot more convenient to fold that loop
> patch into my tree, especially since the block tree in linux-next failed
> after this merge.

I can only agree with you.  It is from the aio-direct tree (probably
misnamed by me) (git://github.com/kleikamp/linux-shaggy.git#for-next) run
by Dave Kleikamp.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__2_Nov_2013_07_22_52_+1100_d2+_P.ARWbIEpCCt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSdA2iAAoJEMDTa8Ir7ZwVyAEP/0g5vyTlZ1PLhLrBCsnHSt03
nwreetoVLetnKVmmwstzwhABigKlxCYExXr1WOKjtIGR2/6x+2BU5sfceOXmKrER
UIX41dhnx2E1awAUmljyqYbKSK1iDf34FFkPdzTO9DKsl0wO38yit7fAgOag40/e
IkciU0t6bYpeNjiPQPO9TNyLmpwsjNy5DOht7vYDIDllwaxeoOh3xQYWfuQUuvlL
txlyh814lXqX7krEJEHd/9DuVVI+yVjBgad+rPzXN/6dS0XAaWi7rybjblMphHph
nm07rE6WfOZZuaRemZD98KGL5zt6J9yvKwF6qoojfPzEwZ79x4DBeZV4f1dOYZv+
hd8utCXeC2Rxwzb7K8jSZ2HwKeacq9JDF+SmRXkxzEEaK9nChBnIFyLEGcT6XWCh
paabjQbn4Vqn9KTUxu0J8FL/qcD/fXWf2IirDmZvO7eRgeYteNCYnIF9NU7yP3/8
1ioEfMPRXxv7CwmSWBhdqZ4Ctncxv2M7yD4hBrvzJbC5XcFO/ZckWmJcOle00Vmd
QKwu9CDhArT9oZXcgZ2Srp4dO5it2NZa+LNkys0oP8+YmcNywNhcAI9f5g2jsVcW
4ZX0x3nJpW2mc7suH0j+2RNL1f7sNkufPcxXEB0K2FtTxjFpPj/L+b+Ic/7jul6S
bNQje2OXfAfKOi+MX4SL
=6+eX
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Nov_2013_07_22_52_+1100_d2+_P.ARWbIEpCCt--
