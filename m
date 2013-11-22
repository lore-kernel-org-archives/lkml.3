Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab3KVIOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 03:14:53 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:35571 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab3KVIOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 03:14:52 -0500
MIME-Version: 1.0
In-Reply-To: <528EBD0B.5010006@innofidei.com>
References: <1385024065-29965-1-git-send-email-zhanghonghui@innofidei.com>
	<CACQ1gAiLesYEWmHkivAF=t8ekCFM=yDDyzkJTtduavNjp1g6wA@mail.gmail.com>
	<528EB1E3.7030101@innofidei.com>
	<20131122015237.GB3509@localhost>
	<528EBD0B.5010006@innofidei.com>
Date: Fri, 22 Nov 2013 09:14:52 +0100
Message-ID: <CAFLxGvyLEEyc2pFJXFU+aLb-ma3EraHLbdFwMm7bxAXJo9M=jw@mail.gmail.com>
Subject: Re: [PATCH] Make the mtdblock read/write skip the bad nand sector
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Hans Zhang <zhanghonghui@innofidei.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Richard Genoud <richard.genoud@gmail.com>, zhouguangming@innofidei.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 3:10 AM, Hans Zhang <zhanghonghui@innofidei.com> wrote:
> On 2013/11/22 9:52, Ezequiel Garcia wrote:
>> On Fri, Nov 22, 2013 at 09:22:43AM +0800, Hans Zhang wrote:
>>> On 2013/11/21 18:59, Richard Genoud wrote:
>>>
>>> Here's my scenario, I want to write nand through mtdblock by dd command
>> You could get some better support by explaining why do you want to write
>> to a NAND through mtdblock. It sounds a bit ackward to me, but I'm sure
>> you have a good reason for it!
>>
>> Let's hear it :-)
>
> Thanks for your reply.
> This is for my embed system upgrade, I reserved one nand partition for filesystem
> environment which will load to DDR while uboot booting.
> This filesystem.uboot file should be able to read both by uboot and kernel, and
> maybe written by uboot and kernel. There will be no filesystems upon the nand in
> case the loader may not support some filesystem types while uboot booting.
>
> Seems that the trimmed environment of OS has get rid of the mtd-tools, So the dd
> command was the most convenience tools to use by hand.

Instead of fixing your userspace you mess around int the kernel?
Sorry, that's a no-no.

-- 
Thanks,
//richard
