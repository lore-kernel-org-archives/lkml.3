Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaKKGDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 01:03:13 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36578 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421AbaKKGDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 01:03:12 -0500
Date: Tue, 11 Nov 2014 13:59:47 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: "tglx@linutronix.de" <tglx@linutronix.de>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/3] irqchip: dw-apb-ictl: IRQ_GC_MASK_CACHE_PER_TYPE
 and PM support
Message-ID: <20141111135947.393a6d78@xhacker>
In-Reply-To: <1411454100-6814-1-git-send-email-jszhang@marvell.com>
References: <1411454100-6814-1-git-send-email-jszhang@marvell.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-11_02:2014-11-10,2014-11-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1411110053
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Thomas, Jason,

Is there any potential issue with this patch serials I need to resolve?

Thanks in advance,
Jisheng

On Mon, 22 Sep 2014 23:34:57 -0700
Jisheng Zhang <jszhang@marvell.com> wrote:

> These patches try to improve dw-apb-ictl irqchip driver a bit.
> 
> The first patch does a bit clean up work -- unify the register access usage.
> 
> The two dw-apb-ictl's irq_chip_type instances have separate mask registers,
> so the second patch enables IRQ_GC_MASK_CACHE_PER_TYPE.
> 
> The last patch adds suspend/resume support to the driver.
> 
> Tested on Marvell BG2Q-DMP board.
> 
> Jisheng Zhang (3):
>   irqchip: dw-apb-ictl: always use use {readl|writel}_relaxed
>   irqchip: dw-apb-ictl: enable IRQ_GC_MASK_CACHE_PER_TYPE
>   irqchip: dw-apb-ictl: add PM support
> 
>  drivers/irqchip/irq-dw-apb-ictl.c | 32 ++++++++++++++++++++++++++------
>  1 file changed, 26 insertions(+), 6 deletions(-)
> 

