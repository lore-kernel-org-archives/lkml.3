Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbaG3OMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:12:24 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:54892 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbaG3OMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:12:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140730133806.GK8181@intel.com>
References: <1406721531-23635-1-git-send-email-a13xp0p0v88@gmail.com>
	<20140730133806.GK8181@intel.com>
Date: Wed, 30 Jul 2014 18:12:17 +0400
Message-ID: <CAF0T0X5pFcxyED+gv5yLv_OKvsweF+XJsf7zi5VUCvOK3bZ6rQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] dmaengine: of: kconfig: select DMA_ENGINE when DMA_OF
 is selected
From: Alexander Popov <a13xp0p0v88@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-30 17:38 GMT+04:00 Vinod Koul <vinod.koul@intel.com>:
> On Wed, Jul 30, 2014 at 03:58:51PM +0400, Alexander Popov wrote:
>> Select DMA_ENGINE when DMA_OF is selected since
>> of_dma_xlate_by_chan_id() from drivers/dma/of-dma.c uses
>> dma_get_slave_channel() from drivers/dma/dmaengine.c
>>
> Please give credit to reporter by adding "Reported-by:" tag in commit
> It is also got practice to give error log
Ok, I got it.

>> Signed-off-by: Alexander Popov <a13xp0p0v88@gmail.com>
> Applied, now after adding reported tag and error log
Thanks, Vinod.

Best regards,
Alexander
