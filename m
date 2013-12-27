Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3L0EcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 23:32:17 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37560 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751917Ab3L0EcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 23:32:15 -0500
X-Sasl-enc: 3rs0F1AYJNTGAEMDUd08TLOuQ20NVeTEYsGHfeBWd7da 1388118734
Subject: [PATCH] Current patch to fix autofs symlink expiry
To: Andrew Morton <akpm@linux-foundation.org>
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 27 Dec 2013 12:32:11 +0800
Message-ID: <20131227042828.3519.11223.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch obsoletes both the current patches:
autofs-fix-symlinks-arent-checked-for-expiry.patch
autofs-fix-fix-symlinks-arent-checked-for-expiry.patch

It's a merge of both of these patches with an updated description.

---

Ian Kent (1):
      autofs - fix symlinks aren't checked for expiry


 fs/autofs4/expire.c  |   14 ++++++++++++++
 fs/autofs4/symlink.c |    4 ++++
 2 files changed, 18 insertions(+)

-- 
Ian
