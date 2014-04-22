Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaDVXux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 19:50:53 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:54419 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaDVXuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 19:50:50 -0400
Date: Tue, 22 Apr 2014 19:50:48 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Liu Hua <sdu.liu@huawei.com>, will.deacon@arm.com, vitalya@ti.com,
        cyril@ti.com, santosh.shilimkar@ti.com, lauraa@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wangnan0@huawei.com, peifeiyue@huawei.com, liusdu@126.co
Subject: Re: [PATCH v3 0/2] change ARM linux memory layout to support 32
 CPUs
In-Reply-To: <20140422213114.GA24070@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.11.1404221949510.980@knanqh.ubzr>
References: <1397559967-26050-1-git-send-email-sdu.liu@huawei.com> <20140422213114.GA24070@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014, Russell King - ARM Linux wrote:

> On Tue, Apr 15, 2014 at 07:06:05PM +0800, Liu Hua wrote:
> > This patch series change fixmap mapping region to suppport 32 CPUs.
> > Because the "top_pmd" covers 0xfffe0000 - 0xffffffff(2M). And part 
> > is used by vector table. So I move this region down to 0xffc00000
> >  - 0xffdffff. 
> 
> Can you explain why you have submitted these patches to my patch tracker
> with a copy to stable@vger.kernel.org ?
> 
> What makes these qualify for stable tree inclusion?  What regression are
> they fixing?
> 
> We don't put patches into the stable tree for things that /never/ worked
> in the past.  We've never supported 32 CPUs so I don't think these
> qualify.

Indeed.  The stable qualifier should be dropped.


Nicolas
