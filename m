Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbaGIRHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:07:22 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:51571 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbaGIRHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:07:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140709183116.506ad2e4@canb.auug.org.au>
References: <20140709183116.506ad2e4@canb.auug.org.au>
Date: Wed, 9 Jul 2014 13:07:18 -0400
Message-ID: <CAPDOMVjAMHOhuzfcJRL_JQ1jSKOeE7PEhppZJKJKbtR2-ixi-A@mail.gmail.com>
Subject: Fwd: linux-next: Tree for Jul 9
From: Nick Krause <xerofoify@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b6da0b4a048f704fdc5bdf6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b6da0b4a048f704fdc5bdf6
Content-Type: text/plain; charset=UTF-8

---------- Forwarded message ----------
From: Stephen Rothwell wrote on Wed, Jul 9, 2014 at 4:31 AM
Subject: linux-next: Tree for Jul 9
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org


Hi all,

Changes since 20140708:

My fixes tree contains:
        powerpc: Disable RELOCATABLE for COMPILE_TEST with PPC64

The net tree lost its build failure.

The net-next tree gained a build failure so I used the version from
next-20140708.

The drm tree gained a conflict against the drm-intel-fixes tree.

The regulator tree lost its build failure.

The iommu tree lost its build failure.

The staging tree still had its build failure for which I disabled a driver.

The rd-docs tree gained a conflict against the trivial tree.

The akpm-current tree still had its build failure for which I applied a
patch.

Non-merge commits (relative to Linus' tree): 4287
 4000 files changed, 161994 insertions(+), 195983 deletions(-)

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
are tracking the linux-next tree using git, you should not use "git pull"
to do so as that will try to merge the new linux-next release with the
old one.  You should use "git fetch" and checkout or reset to the new
master.

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64 and a
multi_v7_defconfig for arm. After the final fixups (if any), it is also
built with powerpc allnoconfig (32 and 64 bit), ppc44x_defconfig and
allyesconfig (this fails its final link) and i386, sparc, sparc64 and arm
defconfig.

Below is a summary of the state of the merge.

I am currently merging 222 trees (counting Linus' and 30 trees of patches
pending for Linus' tree).

Stats about the size of the tree over time can be seen at
http://neuling.org/linux-next-size.html .

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
Gortmaker for triage and bug fixes.

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

Hey Stephen,

A lot of your builds that are failing seem to build for me. Please try
a compiler toolchain
newer then gcc 4.6.3 to see if this is why your builds are failing.
Since all the arm builds
you have failing build for me.
Cheers Nick

--047d7b6da0b4a048f704fdc5bdf6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Disposition: attachment; filename="signature.asc"
Content-Transfer-Encoding: base64
X-Attachment-Id: cb83f2e263218ef1_0.1

LS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0NClZlcnNpb246IEdudVBHIHYyDQoNCmlRSWNC
QUVCQ0FBR0JRSlR2UDNaQUFvSkVNRFRhOElyN1p3VnNwOFAvMGVKT1BtNHozZy84TXF2MElmampK
eFQNCkg0MythL1UyMXdZcHlndnVrRStFd0V0aTRTdnN6YmZtemM0amxneUhKc1hzSmF4ckdOa3Zy
RlJ4RjNkNmw1OUoNCkFnc1JqZ3pUN1g5WWxPZUd1WUwvcmxORTRrRUkvK3R6ZnBacVJtQVkxSkZG
UHFnSVFveStIdHROUlhYVHVXQ2MNCm16Qkk0UURNVTloc3Bvc1hoMGhyNUE2SG1RTWMveFVrOG1s
dXFBUTZTRDMxelNJRVhYSnBiSnUvemRRTFBhY3oNClJEOFdiek5ETTFQRG82VmpmOVlTeFp2TG5j
aWxwcEhtUzk3T1FTVHJxTmtNVm9mRFpLS2xoa0dvd01yekc2UDcNClFtMkFseHVZaGZvTGxBbzc4
VjlEYU5scDc2RzNkbTk0Q1J0TVY0ZUpoTjFmMmdUWWR2Ulk1b1NHcXJtekZUOGcNCnE4eENSQjNJ
ZHpNTWFMMDFraDlVM1k3WTNlUXg5citqR01pOW5OZ3J2ZWUvdVpwbkJORDFGMXZRS0VXbVBBVkQN
CmEydW0rc2lZY1BTMGdZcUorMmEwWlJJY1dDTXNXam5Pa1ZHQ1h4QWh4S2lTRUdYcHlUSlpuYTRh
eTlvRnJBQVcNClRsd3JveTBoZ3B6T1loTXNYc2N1T1Nkc0x2Tkd0U1RBek1OVEJsaHJQd1cvNS9t
T0JuSHZuZHdhZTJLUWNDSEkNClcyTzN1YlJ5ajN6S3NDMTN5T2lyZk9Ca3NucmFRbnZzV0JaUCtP
eG9XN0NJZHNZYmFZSmNsTFNjbmg0eWdLcm8NClZkeHlQSGZBUEJJcERrdm1aSWl1MHRMRkNjMWc0
Ry8xd2VqbG44SFRPOUtyMGpCbGhiSFhPNXpDQWUwWU1RMkENCjE2NTJUbWQ2a3NpVUpvYU13SG9Z
DQo9Z1F4Lw0KLS0tLS1FTkQgUEdQIFNJR05BVFVSRS0tLS0tDQo=
--047d7b6da0b4a048f704fdc5bdf6--
