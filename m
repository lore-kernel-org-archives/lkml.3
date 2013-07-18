Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060Ab3GRPpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:45:40 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:49774 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758992Ab3GRPpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:45:38 -0400
MIME-Version: 1.0
In-Reply-To: <1374162013.1949.119.camel@joe-AO722>
References: <1374161380-12762-1-git-send-email-prabhakar.csengg@gmail.com> <1374162013.1949.119.camel@joe-AO722>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 18 Jul 2013 21:15:15 +0530
Message-ID: <CA+V-a8vBzRnRXhvaLGsQMDhKEAyNDRvnd4QZQ0xnUUo-D3Ek2A@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] media: davinci: vpbe: Replace printk with dev_*
To: Joe Perches <joe@perches.com>
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Thu, Jul 18, 2013 at 9:10 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2013-07-18 at 20:59 +0530, Prabhakar Lad wrote:
>> Use the dev_* message logging API instead of raw printk.
> []
>> diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
> []
>> @@ -595,7 +595,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
>>        * matching with device name
>>        */
>>       if (NULL == vpbe_dev || NULL == dev) {
>> -             printk(KERN_ERR "Null device pointers.\n");
>> +             dev_err(dev, "Null device pointers.\n");
>
> And if dev actually is NULL?
>
Ah nice catch, I overlooked it, I'll fix it.

Regards,
--Prabhakar
