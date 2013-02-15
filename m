Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab3BOR6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:58:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24584 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab3BOR6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:58:08 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: sjenning@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com
Subject: [PATCH] Compile bug-fixes to zcache (v4). 
Date: Fri, 15 Feb 2013 12:53:40 -0500
Message-Id: <1360950824-11032-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <20130214172926.GA17343@kroah.com>
References: <20130214172926.GA17343@kroah.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Then why not just redo that one patch, and send it to me, and then
> rebase all of the other patches on top of it?  That way I can accept the
> "fix the complier warnings" patch now, and the rest can wait.
> 
> thanks,
> 
> greg k-h

Hey Greg,

Please see these four patches which fix compile warnings.

They are also available at
 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/mm.git stable/for-greg-3.9

if you prefer doing a git pull. The branch and this patchset are all
based on git commit 0bcc0429bdb9f7cca3b7ab1f905b0d47031c03e0
"staging: zcache: add TODO file"

Please pull or git am as you see fit.

 drivers/staging/zcache/ramster/ramster.c |  34 +++----
 drivers/staging/zcache/zbud.c            |  34 +++----
 drivers/staging/zcache/zcache-main.c     | 161 ++++++++++++++++---------------
 3 files changed, 115 insertions(+), 114 deletions(-)

Konrad Rzeszutek Wilk (4):
      zcache: Fix compile warnings due to usage of debugfs_create_size_t
      ramster: Fix compile warnings due to usage of debugfs_create_size_t
      zbud: Fix compile warnings due to usage of debugfs_create_size_t
      zcache/zbud: Fix __init mismatch

