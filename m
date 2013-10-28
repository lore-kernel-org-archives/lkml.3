Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab3J1NFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:05:19 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:48268 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab3J1NFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:05:16 -0400
Date: Mon, 28 Oct 2013 14:05:11 +0100
From: Henrik Austad <henrik@austad.us>
To: Jiri Kosina <jkosina@suse.cz>, Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Updating 00-INDEX in Documentation/*
Message-ID: <20131028130511.GA6992@austad.us>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rob, Jiri

If this email goes the wrong place, my sincere apologies, my asbestos=20
underwear can be quickly donned!

I've been reading through some of the docs and one thing that has struct=20
me, is that there is a certain degree of bitrot (textrot?). Almost every=20
category has an outdated 00-INDEX. A couple of indexes has been updated=20
(thanks for applying Jiri!), but more remains.

This is obviously not the most important job to undertake, but it=20
serves as a very convenient starting-point when exploring a given topic.

Hacking away at python shows me that of the 254 subfolders 57 has outdated=
=20
00-INDEX, either with missing files, or files that has been removed. (see=
=20
list below)

Now, I'm quite happy to start fixing this, but what I would like to know=20
before I start:

- is it considered a waste of time? i.e. will it be worth the time
- what is best, a single, big patch, or a series of one patch per=20
  directory?
- or should someone(tm) kick whoever caused 00-INDEX to be outdated, to fix=
=20
  it?

thanks!

List of filesystems with outdated index

  name of dir: (index_not_folder / in_folder_not_index)

filesystems: (5/17)
filesystems/nfs: (1/2)
m68k: (0/1)
serial: (1/2)
leds: (0/4)
arm: (10/7)
blackfin: (0/2)
ide: (1/1)
fb: (3/3)
networking: (3/12)
scsi: (0/8)
power: (1/2)
filesystems: (5/17)
filesystems/nfs: (1/2)
arm: (10/7)
RCU: (0/1)
mmc: (4/0)
fmc: (4/0)
w1: (2/0)
w1/masters: (1/2)
w1/slaves: (0/1)
timers: (0/3)
devicetree: (5/1)
serial: (1/2)
leds: (0/4)
arm: (10/7)
fb: (3/3)
power: (1/2)
mmc: (4/0)
w1: (2/0)
w1/masters: (1/2)
w1/slaves: (0/1)
powerpc: (4/0)
x86: (0/8)
PCI: (1/1)
isdn: (1/0)
powerpc: (4/0)
laptops: (1/2)
vm: (4/7)
virtual: (3/0)
scheduler: (0/1)
x86: (0/8)
s390: (2/2)
filesystems: (5/17)
filesystems/nfs: (1/2)
arm: (10/7)
serial: (1/2)
leds: (0/4)
arm: (10/7)
fb: (3/3)
power: (1/2)
mmc: (4/0)
w1: (2/0)
w1/masters: (1/2)
w1/slaves: (0/1)
powerpc: (4/0)
x86: (0/8)

--=20
Henrik Austad

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlJuYQcACgkQ6k5VT6v45llQ8ACbBAj7fVG6Zifo0JgwmzEGmUmM
5l8AoOMX2pkGy48dJG44Ihjs9J7pc8Zo
=0dAq
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
