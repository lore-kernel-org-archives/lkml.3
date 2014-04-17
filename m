Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaDQREk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:04:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaDQREe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:04:34 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>,
        David Milburn <dmilburn@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH 0/1] ahci: Do not receive interrupts sent by dummy ports
Date: Thu, 17 Apr 2014 18:06:14 +0200
Message-Id: <cover.1397750166.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun, David,

I would expect handle_bad_irq()->print_irq_desc() gets called
if dummy port interrupt arrived. Could be a spurious interrupt
complain as well.

Cc: Tejun Heo <tj@kernel.org>
Cc: David Milburn <dmilburn@redhat.com>
Cc: linux-ide@vger.kernel.org

Alexander Gordeev (1):
  ahci: Do not receive interrupts sent by dummy ports

 drivers/ata/ahci.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

-- 
1.7.7.6

