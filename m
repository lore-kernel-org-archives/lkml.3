Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966487AbaLLVAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 16:00:25 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38532 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964796AbaLLVAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 16:00:24 -0500
Date: Fri, 12 Dec 2014 16:00:21 -0500 (EST)
Message-Id: <20141212.160021.1536714250429818025.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Dec 2014 13:00:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get these two small IDE layer adjustments.

Thanks!

The following changes since commit 6ce4436c9cbe903af935291aa219fd6f4c85722d:

  Merge tag 'please-pull-morepstore' of git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux (2014-12-12 11:34:13 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide.git master

for you to fetch changes up to ca957b6a34a6f7014828f235e35c1945cb955795:

  drivers: ide: Fix mostly harmless off-by-one hardcoded value (2014-12-12 15:26:31 -0500)

----------------------------------------------------------------
Markus Elfring (1):
      IDE: Deletion of an unnecessary check before the function call "module_put"

Rasmus Villemoes (1):
      drivers: ide: Fix mostly harmless off-by-one hardcoded value

 drivers/ide/ide-floppy.c | 4 ++--
 drivers/ide/ide.c        | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)
