Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab3LFHer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 02:34:47 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:43863 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3LFHeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 02:34:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g3rLCtxUBUV-REBvTP6m2ZGXUs4rgjPRr6qbq8OccUuw@mail.gmail.com>
References: <1386207381-28197-1-git-send-email-zhouqiao@marvell.com>
	<1386207381-28197-2-git-send-email-zhouqiao@marvell.com>
	<CAPcyv4g3rLCtxUBUV-REBvTP6m2ZGXUs4rgjPRr6qbq8OccUuw@mail.gmail.com>
Date: Fri, 6 Dec 2013 15:34:44 +0800
Message-ID: <CAN1soZyuHz1Z4mNmc_66jfOe3nxCsgpExQJoMc=NWus8ePAstA@mail.gmail.com>
Subject: Re: [PATCH V2] arm: mmp: build sram driver alone
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Qiao Zhou <zhouqiao@marvell.com>, Eric Miao <eric.y.miao@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Chao Xie <chao.xie@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 10:00 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, Dec 4, 2013 at 5:36 PM, Qiao Zhou <zhouqiao@marvell.com> wrote:
>> sram driver can be used by many chips besides CPU_MMP2, and so build
>> it alone. Also need to select MMP_SRAM for MMP_TDMA driver.
>>
>> Reported-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
>> ---
>
> Looks good, thanks for fixing it up.
>
> --
> Dan


Applied.
