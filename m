Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaBITL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 14:11:26 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5906 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738AbaBITLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 14:11:25 -0500
Message-ID: <52F7D377.7010302@fb.com>
Date: Sun, 9 Feb 2014 14:13:59 -0500
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-09_02:2014-02-07,2014-02-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.26176513681742e-10 kscore.compositescore=0
 circleOfTrustscore=29.4129509548051 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1402090127
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This is a small collection of fixes

Josef Bacik (2) commits (+4/-5):
    Btrfs: don't loop forever if we can't run because of the tree mod log (+1/-0)
    Btrfs: fix assert screwup for the pending move stuff (+3/-5)

David Sterba (1) commits (+1/-1):
    btrfs: reserve no transaction units in btrfs_ioctl_set_features

Filipe David Borba Manana (1) commits (+2/-0):
    Btrfs: fix data corruption when reading/updating compressed extents

Jeff Mahoney (1) commits (+2/-2):
    btrfs: commit transaction after setting label and features

Total: (5) commits (+9/-8)

 fs/btrfs/compression.c | 2 ++
 fs/btrfs/extent-tree.c | 1 +
 fs/btrfs/ioctl.c       | 6 +++---
 fs/btrfs/send.c        | 8 +++-----
 4 files changed, 9 insertions(+), 8 deletions(-)
