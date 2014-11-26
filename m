Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbaKZKAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 05:00:36 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:55669 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaKZKAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 05:00:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAM4voamo307W_v8gy-eegTmV+yBSQG8eRKLgFxredR2SJt6PPA@mail.gmail.com>
References: <1416918346-2442-1-git-send-email-r.baldyga@samsung.com>
	<1416918346-2442-2-git-send-email-r.baldyga@samsung.com>
	<54748A87.4040500@samsung.com>
	<CAM4voamo307W_v8gy-eegTmV+yBSQG8eRKLgFxredR2SJt6PPA@mail.gmail.com>
Date: Wed, 26 Nov 2014 15:30:32 +0530
Message-ID: <CAAgF-BeA+Es4K0Dvtm1+aQVpem8=MwYSdQs3Ta8J+khVvj7Zpg@mail.gmail.com>
Subject: Re: [PATCH 1/2] dma: pl330: improve pl330_tx_status() function
From: Padma Venkat <padma.kvr@gmail.com>
To: r.baldyga@samsung.com
Cc: Vinod Koul <vinod.koul@intel.com>, dan.j.williams@intel.com,
        lars@metafoo.de, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>, l.czerwinski@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

I tested your patches on exynos5420 peach-pit with audio playback and
got some underrun error.
I posted a similar patch in the below link.

https://patchwork.kernel.org/patch/5384551/

Please do review the same.

Thanks
Padma

> On 25.11.2014 13:25, Robert Baldyga wrote:
>> This patch adds possibility to read residue of DMA transfer. It's useful
>> when we want to know how many bytes have been transfered before we
>> terminate channel. It can take place, for example, on timeout interrupt.
>>
>> Signed-off-by: Lukasz Czerwinski <l.czerwinski@samsung.com>
>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
>> ---
>>  drivers/dma/pl330.c | 61
>> ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 60 insertions(+), 1 deletion(-)
>>
