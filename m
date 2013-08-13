Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab3HMHxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:53:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34580 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab3HMHxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:53:40 -0400
Date: Tue, 13 Aug 2013 17:53:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Dave Chinner <dchinner@redhat.com>
Subject: linux-next: manual merge of the akpm tree with the staging tree
Message-Id: <20130813175332.3db3f440e9419326c83360aa@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Aug_2013_17_53_32_+1000_dw4hfxG3+N6bf.zb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Aug_2013_17_53_32_+1000_dw4hfxG3+N6bf.zb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/staging/zcache/zcache-main.c between commit 962564604873
("staging: zcache: delete it") from the staging tree and commits "drivers:
convert shrinkers to new count/scan API" and
"drivers-convert-shrinkers-to-new-count-scan-api-fix" from the akpm tree.

I fixed it up (I just removed the file) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__13_Aug_2013_17_53_32_+1000_dw4hfxG3+N6bf.zb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSCeYAAAoJEECxmPOUX5FEH2MP/j9GV1TeIfHl1PRp9W2p15yl
YPY+o982+9S797DAUYRb/nAdVd4I/CTqX/ntBJ82z7nd9DHiv1yvzDPnhhkD5fKK
35kf9B9Ti3j0QDejX2jIRObeeWeLD1E1N8/udaREf8vmglBspmOK9buYeLlTDxiv
g/w7BP9/Orfo9BpQ3uUX5Zi5NtgASE+UZ0q815waYfrQuPbW+heOJsKEriAwfUXX
W884ifqNGhI5JTUwstbTsToHqTQMU5AL3cRGhH62b2cVOmf7LZpZ8NU5Bh/o+cQS
eG1vLVbFnIxbGEuwpsicA9w3wL1yYAGL9FDWMzQMFtpovFrUSXZVc4jnXZQsYRfJ
rv8I1ZF4OCf6bL80zqC7lcvK3z6gIbxAlvUfBGdu2p505bWr0b4+33hFDEvRtwg1
NcjLnPZorN5BLJCorEEhLNRcKkdJxsVjgqZZqTv5Ihn60lVCR4awWFo99z4X9Srq
p1zFI+RcRmNhhZlsQDtAztfErKDy/GDJZOpyb1X4VbBe8lMFhgZtpvgtT9OL2QP7
/UIfGQeDpFNAvCtFmYqrppaYc4Jbnty4LKYJh+gCKQfSvDRuZ0ylR3oqTLOPOMCh
gmL1W5jrFlOcVxpzp9UIkNWyi3mvlgvOCBwapgo+jdLzfVhTpwpMvpI/S9/ngH/2
m5YSi/TYGpBMCLxv7/EK
=gWxH
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Aug_2013_17_53_32_+1000_dw4hfxG3+N6bf.zb--
