Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbaISTr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 15:47:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11888 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932080AbaISTrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 15:47:24 -0400
Message-ID: <541C8845.4080101@fb.com>
Date: Fri, 19 Sep 2014 15:47:17 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-19_07:2014-09-19,2014-09-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.46549439250521e-13 kscore.compositescore=0
 circleOfTrustscore=28.9261618248808 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1409190165
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

We have two more fixes for pulling:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

I've got a  revert to fix a regression with btrfs device registration,
and Filipe has part two of his fsync fix from last week.

Chris Mason (1) commits (+6/-7):
    Revert "Btrfs: device_list_add() should not update list when mounted"

Filipe Manana (1) commits (+13/-14):
    Btrfs: set inode's logged_trans/last_log_commit after ranged fsync

Total: (2) commits (+19/-21)

 fs/btrfs/btrfs_inode.h | 13 +++++++++++--
 fs/btrfs/tree-log.c    | 14 ++------------
 fs/btrfs/volumes.c     | 13 ++++++-------
 3 files changed, 19 insertions(+), 21 deletions(-)
