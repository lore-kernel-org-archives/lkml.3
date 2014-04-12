Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaDLOcc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 10:32:32 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:33031 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaDLOcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 10:32:31 -0400
Date: Sat, 12 Apr 2014 10:32:27 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Liu hua <sdu.liu@huawei.com>
cc: linux@arm.linux.org.uk, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wangnan0@huawei.com, peifeiyue@huawei.com, liusdu@126.com,
        m.szyprowski@samsung.com
Subject: Re: [PATCH v2 1/2] ARM : DMA : remove useless information about
 DMA
In-Reply-To: <5348C040.1060305@huawei.com>
Message-ID: <alpine.LFD.2.11.1404121031170.980@knanqh.ubzr>
References: <1397203252-22977-1-git-send-email-sdu.liu@huawei.com> <1397203252-22977-2-git-send-email-sdu.liu@huawei.com> <alpine.LFD.2.11.1404112252050.980@knanqh.ubzr> <5348C040.1060305@huawei.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2014, Liu hua wrote:

> Hi Nicolas,
> 
> Your version is better. you tell me this in the former letters.
> So I am very sorry to forget to check that.
> 
> May be I should remake this second patch to fit your change. What do
> you think about that patch?

You may simply drop your first patch and only keep the other two.


Nicolas
