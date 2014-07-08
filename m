Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbaGHSbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:31:05 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:62682 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbaGHSbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:31:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140707164244.18699ce8@canb.auug.org.au>
References: <20140707164244.18699ce8@canb.auug.org.au>
Date: Tue, 8 Jul 2014 14:30:59 -0400
Message-ID: <CAPDOMVgiR2kKpOmnWv70fUFcMyDzaxxHrec6eSOWF8qW38nc3w@mail.gmail.com>
Subject: Fwd: linux-next: Tree for Jul 7
From: Nick Krause <xerofoify@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Content-Type: multipart/mixed; boundary=bcaec548a7a313f5ce04fdb2cb83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec548a7a313f5ce04fdb2cb83
Content-Type: text/plain; charset=UTF-8

---------- Forwarded message ----------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, Jul 7, 2014 at 2:42 AM
Subject: linux-next: Tree for Jul 7
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org


Hi all,

Changes since 20140704:

My fixes tree contains:
        powerpc: Disable RELOCATABLE for COMPILE_TEST with PPC64

The net tree still had its build failure for which I reverted a commit.

The mvebu tree gained a conflict against the arm tree.

The renesas tree gained a conflict against the arm tree.

The staging tree still had its build failure for which I disabled a driver.

The akpm-current tree still had its build failure for which I applied a
patch.

Non-merge commits (relative to Linus' tree): 3683
 3559 files changed, 139800 insertions(+), 187348 deletions(-)

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


I am testing your tests again for the failing cases. Below is my list
of what failing tests
are pasting for me and which are still failing.
Cheers Nick


Arm - All succeed
Blackfin - BF561-ACVILON_defconfig fails , BlackStamp_defconfig Fails
, TCM-BF518_defconfig succeeds
Cris - cris-allmodconfig fails ,cris-allyesconfig fails
or32 -no compiler
powerpc - allyesconfig fails without a patch I have sent to maintainer
of this arch
s390 - s390-allnoconfig succeeds
sh4- rsk7203_defconfig fails, se7722_defconfig succeeds,
shx3_defconfig fails ,ecovec24-romimage_defconfig succeeds
,kfr2r09-romimage_defconfig succeeds,
kfr2r09_defconfig succeeds , sh7724_generic_defconfig succeeds,
sh7770_generic_defconfig succeeds, sh-allmodconfig fails,
sh-allyesconfig fails
Sparc64 - sparc-allmodconfig seems to pass
1386-um -  um-defconfig succeeds

--bcaec548a7a313f5ce04fdb2cb83
Content-Type: application/pgp-signature; name="signature.asc"
Content-Disposition: attachment; filename="signature.asc"
Content-Transfer-Encoding: base64
X-Attachment-Id: 76c207c52da00d4f_0.1

LS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0NClZlcnNpb246IEdudVBHIHYyDQoNCmlRSWNC
QUVCQ0FBR0JRSlR1a0ZzQUFvSkVNRFRhOElyN1p3VnlLOFAvajVmZE9yUHR2K0JBdXNVUzlkWG1M
RzgNClYwbnQ0d09ORXdrRW1TS1JiWXZFd2ZTT1hYZk85ZnQxbCtTTFkybDNLOEZUYStPNlo1S002
ejRjdURUdmk4NzENClRWd1RGUTNvVHFQNncyajYwd1E0WXJOSkZWeUd0dk9TQU10aTFSb1c3c292
WTNwNklkZHl1b0h2NDFtWUNRNmcNCndiNWk1a25BYWpGSUp2SHBucGUyV1hvZUFzcnBMamNYV0RW
endSQm9tMk9vdWUwRk0zUlgveWU5ZFZibU1DT2oNClpCbk5nSk9RTllSVDhzVWhzY2hiRkcwMFVT
Y0V5VjdDRVhpMEFicU9BQzVydFZQalY4ZDc2MVlIS3NnQ0RzMVANCnJ6YUlkcENyV1VXbWt0L25C
MncrdWdhUTJRSm5PalB4anBCd3hLS0wvcHBIRFJwd3NGSzROUjRlOThKM0tndnYNCkltRDZQN1c5
clRyc0t4S1d5c0k5VmtSL3NkUVFFREdnUHRLSHcybW1jWTB6Y3k5dmlVV3R5bGs2N255VFhtc0EN
CmJmN1FPaDVVSXE1M0xMTk5KMFliVEZabGdaTHMxODJpMk1SVzZTN2hQaVBLQ1dtQ0k5Y2JRWmZ0
M3g2TjNpL1QNCkU4ZE10SzArZGtRNCtkRHZVSDVDSEFhaWQzR2MwNHhXYTQ4engvYWxpOWk2blhh
MUJFNHNHd2w3VmcrS1cvK1gNCkh0S2ZGQmV5NkEvZjJkV0M2OTRUeHNlZEc0Sk9PMXR2clRuU3Q5
alhGV3oxR2o0eTV4VGgrbTFGWEZRSjhBa1cNCldmM1JaZVI1WEltNTBEMWxXT0EveHBIdFlzR0h5
SENMSjNDZHlMajhnU3U5S3o2bGxKODBlVjgxTCt6VDc2MCsNClZ0KzE4VFVxUXJYd0pEWCt0NFAz
DQo9QkcvSw0KLS0tLS1FTkQgUEdQIFNJR05BVFVSRS0tLS0tDQo=
--bcaec548a7a313f5ce04fdb2cb83--
