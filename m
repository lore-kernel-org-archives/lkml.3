Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab3EWJHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 05:07:49 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61778 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415Ab3EWJHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 05:07:48 -0400
MIME-Version: 1.0
In-Reply-To: <201305231051.40961.hverkuil@xs4all.nl>
References: <1368619042-28252-1-git-send-email-prabhakar.csengg@gmail.com> <201305231051.40961.hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 23 May 2013 14:37:27 +0530
Message-ID: <CA+V-a8u=j-fZiQoJZMipWQ1uKo_nkU82Pugsv62oo=MDvfKTEA@mail.gmail.com>
Subject: Re: [PATCH 0/6] media: i2c: ths7303 feature enhancement and cleanup
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Thu, May 23, 2013 at 2:21 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Wed 15 May 2013 13:57:16 Lad Prabhakar wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> This patch series enables the ths7303 driver for asynchronous probing, OF
>> support with some cleanup patches.
>>
>> Lad, Prabhakar (6):
>>   media: i2c: ths7303: remove init_enable option from pdata
>>   ARM: davinci: dm365 evm: remove init_enable from ths7303 pdata
>>   media: i2c: ths7303: remove unnecessary function ths7303_setup()
>>   media: i2c: ths7303: make the pdata as a constant pointer
>>   media: i2c: ths7303: add support for asynchronous probing
>>   media: i2c: ths7303: add OF support
>
> Can you post this again in the right order (swapping the first two patches)
> and preferably with an ack from the mach-davinci maintainer?
>
> Once I have that I can take in the first four patches and I can take the
> final two patches once the async support is merged.
>
Ok I'll do it today.

Regards,
--Prabhakar Lad
