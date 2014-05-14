Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbaENK7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 06:59:46 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:64400 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbaENK7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 06:59:43 -0400
Subject: [PATCH 1.2 0/16] arcmsr: bugfix and support new adapters ARC12x4
 series
From: ching <ching2048@areca.com.tw>
Cc: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com,
        agordeev@redhat.com, linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 May 2014 18:59:35 +0800
Message-ID: <1400065175.6957.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In last patch v1.1 16/16 series, patch2 has been updated several time.
The patch line number, from patch3 to patch16, are all shifted.
So I repost the corrected patch files, patch v1.2 17/16 series.

In the meantime, I add a new patch 17 to fix of calling scsi_scan_host() after every initialization are done.

Thanks,
Ching

