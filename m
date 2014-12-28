Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaL1O1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 09:27:19 -0500
Received: from mout.web.de ([212.227.15.4]:51835 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbaL1O1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 09:27:01 -0500
Message-ID: <54A01326.3050306@users.sourceforge.net>
Date: Sun, 28 Dec 2014 15:26:46 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>, Ron Minnich <rminnich@sandia.gov>,
        v9fs-developer@lists.sourceforge.net
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 0/8] fs/9p: Deletion of some unnecessary checks
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:NiAg6488mz27Wdmg8xPoGEpC/mWf2lVWXbKYrEGf1wX6HCRp0EZ
 L6frDIGdCo9FBz5rKSQcE1q8+R0EBI5DKjoJJp5LU7KFLJdHVoNgcvWEYxb5ZRl2dmdTyVd
 FqpulTYiWyy0IstjpQ2whs8V+rTYfFhxCV6LsmMuBiGryLCBArDsQc0YM0+7shjo1e/1fPC
 tRv+9WWaYhocBKu5qRAng==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 28 Dec 2014 14:50:08 +0100

Further update suggestions were taken into account after a patch was applied
from static source code analysis.

Markus Elfring (8):
  Deletion of unnecessary checks before the function call "p9_client_clunk"
  One function call less in v9fs_create() after error detection
  One function call less in v9fs_vfs_atomic_open() after error detection
  One function call less in v9fs_fid_xattr_get() after error detection
  One function call less in v9fs_vfs_atomic_open_dotl() after error detection
  Less function calls in v9fs_vfs_mkdir_dotl() after error detection
  One function call less in v9fs_vfs_symlink_dotl() after error detection
  Less function calls in v9fs_vfs_mknod_dotl() after error detection

 fs/9p/vfs_dir.c        |  3 +--
 fs/9p/vfs_inode.c      | 25 ++++++++++--------------
 fs/9p/vfs_inode_dotl.c | 52 +++++++++++++++++++++-----------------------------
 fs/9p/xattr.c          |  6 ++----
 4 files changed, 35 insertions(+), 51 deletions(-)

-- 
2.2.1

