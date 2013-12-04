Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab3LDTRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 14:17:18 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:47687 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136Ab3LDTRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:17:15 -0500
MIME-Version: 1.0
In-Reply-To: <529F10D6.4000307@marvell.com>
References: <1386145275-27438-1-git-send-email-zhouqiao@marvell.com>
	<CAN1soZzWUh74FHeKs3acLpfQYhQBNzES9nB1tJNvwV1h4zi1Lw@mail.gmail.com>
	<529F10D6.4000307@marvell.com>
Date: Wed, 4 Dec 2013 11:17:14 -0800
Message-ID: <CAPcyv4jELNXN7+f2MvD8FuUmvRCbAw7DG=cNMHuPrYWcWAo5BA@mail.gmail.com>
Subject: Re: [PATCH 0/2 V1] arm-mmp-build-sram-driver-alone
From: Dan Williams <dan.j.williams@intel.com>
To: Qiao Zhou <zhouqiao@marvell.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Miao Eric <eric.y.miao@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Chao Xie <cxie4@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 4, 2013 at 3:24 AM, Qiao Zhou <zhouqiao@marvell.com> wrote:
> On 12/04/2013 07:17 PM, Haojian Zhuang wrote:
>>
>> Dan indicated that you could pack these two patches into one. Whatever
>> it's also OK to use two patches.
>
> Misunderstood it... Thanks for correcting.
>

Please combine the patches for two reasons:
1/ patch1 by itself makes the problem worse it prevents the mmp_tdma
driver from building even if CPU_MMP2 is selected.
2/ patch2 does not have a changelog and is the only user of the
enabling in patch1
