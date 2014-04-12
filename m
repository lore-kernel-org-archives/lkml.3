Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbaDLDMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 23:12:36 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:47320 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbaDLDMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 23:12:35 -0400
Date: Fri, 11 Apr 2014 23:12:31 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Liu Hua <sdu.liu@huawei.com>
cc: linux@arm.linux.org.uk, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wangnan0@huawei.com, peifeiyue@huawei.com, liusdu@126.com,
        m.szyprowski@samsung.com
Subject: Re: [PATCH v2 1/2] ARM : DMA : remove useless information about
 DMA
In-Reply-To: <1397203252-22977-2-git-send-email-sdu.liu@huawei.com>
Message-ID: <alpine.LFD.2.11.1404112252050.980@knanqh.ubzr>
References: <1397203252-22977-1-git-send-email-sdu.liu@huawei.com> <1397203252-22977-2-git-send-email-sdu.liu@huawei.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2014, Liu Hua wrote:

> Because commit e9da6e9905e6 has remove custom consistent dma
> region. So the related variable and document should be removed
> 
> Signed-off-by: Liu Hua <sdu.liu@huawei.com>

Acked-by: Nicolas Pitre <nico@linaro.org>

Incidentally I sent an identical patch to RMK's patch system:

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8023/1

Either version is fine with me.


Nicolas
