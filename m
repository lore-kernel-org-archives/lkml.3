Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3EEKGZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 06:06:25 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:45086 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab3EEKGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 06:06:24 -0400
Message-ID: <51862F32.9000104@gmail.com>
Date: Sun, 05 May 2013 18:06:42 +0800
From: Libo Chen <chenlibo.3@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: davidb@codeaurora.org, ohad@wizery.com, joerg.roedel@amd.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lizefan@huawei.com, libo.chen@huawei.com
Subject: [PATCH 0/2] msm: iommu: fix two mistake
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: libo.chen@huawei.com

Sorry, I am not sure who this patch should be send to.

Libo Chen (2):
  msm: iommu: add missing platform_device_unregister() in err case
  msm: iommu: no need kfree before kzalloc successful

 drivers/iommu/msm_iommu_dev.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

-- 
1.8.1.2
