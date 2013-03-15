Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab3COENp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 00:13:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54926 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3COENo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 00:13:44 -0400
Date: Fri, 15 Mar 2013 15:13:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: linux-next: manual merge of the staging tree with Linus' tree
Message-Id: <20130315151334.2b52f63ab7f6b1efb893bf3e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__15_Mar_2013_15_13_34_+1100_9lGGW6Cg/VEpS3Cz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Mar_2013_15_13_34_+1100_9lGGW6Cg/VEpS3Cz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/ccg/f_fs.c between commit 7f78e0351394 ("fs: Limit
sys_mount to only request filesystem modules") from Linus' tree and
commit 515e6dd20b3f ("Staging: ccg: delete it from the tree") from the
staging tree.

The latter deleted the file, so I did that and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__15_Mar_2013_15_13_34_+1100_9lGGW6Cg/VEpS3Cz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBCAAGBQJRQp/uAAoJEECxmPOUX5FEL3IP92BNx1HMR7pHGpCNCBAlaqii
6sDLCPGEUhhW/2U06XYiNQkFtCmpToCU/Ytzp85ht6P0wgEe2KhMHbyM15t4UJ02
WJezcna5FLIE0w4+ft9Fzcu/6DlSJJkOUa8JX1ucZB1F4nESKm7YUajXsguei757
wprAB63lE5iZsNJi23o25zSKTCPQYND7ofTneRPgdliaTnu/dbh+G9JOUr8JCtSk
3EHgpgAWBGewlzdHQGAt9VkHWljgLLbqCvwOPmrgqCYvfr4BMZ9y98zwNtn0MDfd
44WrO3YYuTto7Ohgf+z8QBCSaG7WQMsjvtptFMcqgIo6LtNzG2Aj0VkIHg9ecJ6o
jMsWbmJrNGw0ON1sXUR6j8ORKSISyIUlHKtK9PCPjRIJPFIPJe8U50i+fnK6xpfy
Kb4pakqL5exzM7x4VadIusn9eyZGMtZIYI/+bk+3tdyy9hjSDsg+RlAVbNyxS/hF
5RpKPZ2PeephDDLVqUTPcvtD5h0G2X1Ohoi0Bn3DZ6Kz8evDv7E5v7E9KRduAdPR
7L+3lsWp3CM1aHaeEK0JiemhKe7WU3ovpY+/SF2pKPMKynlZhW6Dt7y9pyho0OVr
QciJoRVOZjy9TzromE9Eg5w5cHSwu2NrGKpXyNUKD28pB++KEiyWNsBmO7e6WST4
lloK0L3A/T7SpAcX+ig=
=Knpo
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Mar_2013_15_13_34_+1100_9lGGW6Cg/VEpS3Cz--
