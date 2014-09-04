Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbaIDW5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 18:57:13 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50609 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaIDW5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 18:57:11 -0400
Date: Thu, 4 Sep 2014 23:57:03 +0100
From: Mark Brown <broonie@kernel.org>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140904225703.GA29327@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OhJ1ewkhZtPPLZD8"
Content-Disposition: inline
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: linux-next: Tree for Sep 3
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OhJ1ewkhZtPPLZD8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Changes since 20140903:

The LED tree gained a conflict against Linus' tree which I resolved.

Non-merge commits (relative to Linus' tree): 3552
 3034 files changed, 118938 insertions(+), 89190 deletions(-)

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git .
If you are tracking the linux-next tree using git, you should not use
git pull" to do so as that will try to merge the new linux-next release
with the old one.  You should use "git fetch" and checkout or reset to
the new master.

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with an
allmodconfig for x86_64 and a multi_v7_defconfig for arm.

Below is a summary of the state of the merge.

I am currently merging 215 trees (counting Linus' and 30 trees of patches
pending for Linus' tree).

Stats about the size of the tree over time can be seen at
http://neuling.org/linux-next-size.html .

Status of Stephen's local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

--OhJ1ewkhZtPPLZD8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUCO48AAoJELSic+t+oim9saYP/3tWhzIXvytStEQ2E6tKeJYV
zHnTROqEQbYLyQ65IDcLwvdDeUM92LuH8sw8uV0F3ELM2hFFFwhynQVxd25Clwzt
oC+JStk+yBIMLW0PP+kxBrGtKV0Cpc6CraI4uvvCmq8BzSl1P+NKYTiJNOQTjbwk
Go9+e+w/f0FhR8pB4pUkonvRn00zhphOJ+3WZ7MgwIJR4pfZw4Ek07VXj56H9THH
V1lpkP1AGvlRlZnUMcFrhe2OLNMBkAZuYwnIwi/6hTPhYmd5C/x7p2OvnzDz/mGR
9sKi07L6PzhIUPnO4k2dNUupKlzoVRrG2fqSYD4POyKGpnNerSohq8yE//0s4jvP
E4WGtxSbcYOdwsw5j+QIH5Bn2zrWHK4BkjH9moX9xDwhvhdFBkJ4PlIeYGhc3QFV
U7EeMvYkmNPS1OfQ2es87DQDcluOj4Lab8/njNB1JA19sdvusmyNxvi2VLgFBiT1
wFI2EsonqVI80+xL1SkdpwWPMopTI7Qmg8SAZW7Ib4p/rsGCJ2IridNgv36P33gj
91xgv4O5LnRq66Y2HGdrjOaQDbAzq6fOHbY6wpN7V1U8w0ADkexcaSdUr4cFMQ3G
oKCktwe1UiFmJimHKPry8U/pqjf8rFMPPH/yiOV07FDwvyUVlCWonhDpclQXCUKh
9EY2ITe8PbozBGTQ7CnI
=zQhZ
-----END PGP SIGNATURE-----

--OhJ1ewkhZtPPLZD8--
