Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaJOSpD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 14:45:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53303 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaJOSpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 14:45:00 -0400
Date: Wed, 15 Oct 2014 14:44:58 -0400 (EDT)
Message-Id: <20141015.144458.419565536254879281.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Oct 2014 11:45:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this one IDE driver cleanup.

Thanks!

The following changes since commit 0429fbc0bdc297d64188483ba029a23773ae07b0:

  Merge branch 'for-3.18-consistent-ops' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu (2014-10-15 07:48:18 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide.git master

for you to fetch changes up to 7546e52b5e3d46d0deae4a336252b6dfd52c6571:

  Drivers: ide: Remove typedef atiixp_ide_timing (2014-10-15 14:27:38 -0400)

----------------------------------------------------------------
Himangi Saraogi (1):
      Drivers: ide: Remove typedef atiixp_ide_timing

 drivers/ide/atiixp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)
