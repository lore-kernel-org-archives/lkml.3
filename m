Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab3LCFLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 00:11:36 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40222 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065Ab3LCFLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 00:11:34 -0500
X-Sasl-enc: egUWkK+DYJujEhho2TVujUZ2FHQPJk7QYfhHQdavoZZM 1386047492
Subject: [PATCH 0/2] A couple of maintenance fixes for autofs
To: Andrew Morton <akpm@linux-foundation.org>
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Rui Xiang <rui.xiang@huawei.com>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 03 Dec 2013 13:11:29 +0800
Message-ID: <20131203050323.15048.52933.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here are a couple of fixes for autofs.

The first patch fixes a couple of potential incorrect error returns
from autofs4_fill_super() so it's probably worthwhile to mege this
sooner rather than later.

The later is purely an improvement to using the IS_ROOT() macro.

---

Rui Xiang (2):
      autofs: fix the return value of autofs4_fill_super
      autofs: use IS_ROOT to replace root dentry checks


 fs/autofs4/inode.c |   13 ++++++++-----
 fs/autofs4/root.c  |    6 +++---
 2 files changed, 11 insertions(+), 8 deletions(-)

-- 
Ian
