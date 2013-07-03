Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3GCBKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 21:10:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37266 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3GCBKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 21:10:41 -0400
Date: Wed, 3 Jul 2013 11:10:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the xilinx tree
Message-Id: <20130703111030.c0df2a231fc3e4ba6cb566cd@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Jul_2013_11_10_30_+1000_/u_cb/6Z9IfA1T3y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Jul_2013_11_10_30_+1000_/u_cb/6Z9IfA1T3y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

Today's linux-next merge of the xilinx tree got conflicts in several files.

These conflicts are caused by a set of old patches in the xilinx tree
other copies of which have been merged upstream a while ago.  I fact the
xilinx tree currently adds no changes to linux-next at all.   Could you
please clean up this tree?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__3_Jul_2013_11_10_30_+1000_/u_cb/6Z9IfA1T3y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR03oLAAoJEECxmPOUX5FEpHcQAIxEmgfsHoLjPHE/8yiVyI7J
Gd8mDrBtdQSfFoOujb22bxWLA52ZpdNTyZ3WDbQKcNApgHl2yIqSzlCFWLvqh/Oi
HzUzbcwfzdcv4EUcrTUS1khvz3+JPpGyf3Wlvxfa6YqrrtGnU/QEx4ZSLb5iBcV1
fDbR85tht/K2fmCEwa+dxZ47Zn3F4F00rYMZgdBKFBy6X4wGhiWtZLeh6WtPPPoT
7EtXLh9uvJD50PqUE9tKGJV88nqup38vUrqmLE6BtDJ/eYDM109mIUa3YIXmw6Pa
nOPoQNBXiIVwknTPfWGKzpsQdxJzxtgt4cTNVmquQrPXdSczQl/SaSIVl9eoV8JQ
UBRqn61V5D6M/e1x2CYk7ItD6XTM5ksMpqF8E6zauT2f2eqN0X12tMF0Os2ydq1W
EMnaGZQjTl7v/KAE7YkTJ5sKHEbqQRWEGH4cVw6WBNAP99GARqmEzzU5TKSQnj30
BYaz18pbY/O7uvf7gGvd7v0eVgHauUR7JaSMvS4m9PY1gmmO0Dy/il6Zmmvy8DFP
ndEmsY/S2atGy0BWU1LpCwR/CdRQY5SjfA7eYOSUSUuew2ENox0MCBZ87beqsqZg
7X9k1ViKH9MFw9WmPllqwI0UVl5TrZNKhRoWjjGHTdhGaeAeHlnoSeb9AYie+18B
1OvXq0ySCKcCkP8yn9kP
=XU/Y
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Jul_2013_11_10_30_+1000_/u_cb/6Z9IfA1T3y--
