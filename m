Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab3KNX33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 18:29:29 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53743 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab3KNX3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 18:29:20 -0500
Date: Thu, 14 Nov 2013 18:29:18 -0500 (EST)
Message-Id: <20131114.182918.7368302396246095.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 14 Nov 2013 15:29:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just some minor cleanups and simplifications.

Please pull, thanks a lot!

The following changes since commit 4fbf888accb39af423f271111d44e8186f053723:

  Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2013-11-14 17:19:58 +0900)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide.git master

for you to fetch changes up to c2f7d1e103ef1b5f3bd6a8a09aebf5eac7df4aca:

  ide: pmac: remove unnecessary pci_set_drvdata() (2013-11-14 18:21:25 -0500)

----------------------------------------------------------------
Jingoo Han (3):
      ide: pmac: Remove casting the return value which is a void pointer
      ide: cs5536: use module_pci_driver()
      ide: pmac: remove unnecessary pci_set_drvdata()

 drivers/ide/cs5536.c | 13 +------------
 drivers/ide/pmac.c   | 52 +++++++++++++++++-----------------------------------
 2 files changed, 18 insertions(+), 47 deletions(-)
