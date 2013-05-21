Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab3EUTBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 15:01:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab3EUTBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 15:01:48 -0400
Date: Tue, 21 May 2013 21:03:05 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>, Jan Beulich <JBeulich@suse.com>
Subject: [PATCH RESEND 0/1] AHCI: Make distinct names for ports in
 /proc/interrupts
Message-ID: <cover.1369161950.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

This patch is applied on top of previously (re)sent patch
"AHCI: Optimize interrupt processing". Should the latter
refused, I will post a new version.

Alexander Gordeev (1):
  AHCI: Make distinct names for ports in /proc/interrupts

 drivers/ata/ahci.c    |    5 +++--
 drivers/ata/ahci.h    |    1 +
 drivers/ata/libahci.c |   10 ++++++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
