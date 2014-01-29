Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaA2Iuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 03:50:55 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49631 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaA2Iux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 03:50:53 -0500
Date: Wed, 29 Jan 2014 00:50:53 -0800 (PST)
Message-Id: <20140129.005053.2082541589188028703.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two header file inclusion fixes from Rashika Kheria.

Please pull, thanks a lot!

The following changes since commit 0e47c969c65e213421450c31043353ebe3c67e0c:

  Merge tag 'for-linus-20140127' of git://git.infradead.org/linux-mtd (2014-01-28 18:56:37 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide.git master

for you to fetch changes up to 61eae5bb06496a6633ba000a1d7546b494e00081:

  drivers: ide: Include appropriate header file in ide-pio-blacklist.c (2014-01-28 23:35:09 -0800)

----------------------------------------------------------------
Rashika Kheria (2):
      drivers: ide: Include appropriate header file in ide-cd_verbose.c
      drivers: ide: Include appropriate header file in ide-pio-blacklist.c

 drivers/ide/ide-cd_verbose.c    | 2 ++
 drivers/ide/ide-pio-blacklist.c | 1 +
 2 files changed, 3 insertions(+)
