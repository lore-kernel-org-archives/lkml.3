Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934470Ab3DSVsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 17:48:51 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:57147 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933583Ab3DSVst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 17:48:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130419213152.GD11866@zurbaran>
References: <1366304318-29620-1-git-send-email-andrew.smirnov@gmail.com>
	<20130419213152.GD11866@zurbaran>
Date: Fri, 19 Apr 2013 14:48:48 -0700
Message-ID: <CAHQ1cqFO7PBLchW6bQJ-t07dmhneyzpVY=MMAft0Se9cYZ2gTw@mail.gmail.com>
Subject: Re: [PATCH v9 00/12] Driver for Si476x series of chips
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 2:31 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Andrey,
>
> On Thu, Apr 18, 2013 at 09:58:26AM -0700, Andrey Smirnov wrote:
>> Driver for Si476x series of chips
>>
>> This is a eight version of the patchset originaly posted here:
>> https://lkml.org/lkml/2012/9/13/590
>>
>> Second version of the patch was posted here:
>> https://lkml.org/lkml/2012/10/5/598
>>
>> Third version of the patch was posted here:
>> https://lkml.org/lkml/2012/10/23/510
>>
>> Fourth version of the patch was posted here:
>> https://lkml.org/lkml/2013/2/18/572
>>
>> Fifth version of the patch was posted here:
>> https://lkml.org/lkml/2013/2/26/45
>>
>> Sixth version of the patch was posted here:
>> https://lkml.org/lkml/2013/2/26/257
>>
>> Seventh version of the patch was posted here:
>> https://lkml.org/lkml/2013/2/27/22
>>
>> Eighth version of the patch was posted here:
>> https://lkml.org/lkml/2013/3/26/891
>>
>> To save everyone's time I'll repost the original description of it:
>>
>> This patchset contains a driver for a Silicon Laboratories 476x series
>> of radio tuners. The driver itself is implemented as an MFD devices
>> comprised of three parts:
>>  1. Core device that provides all the other devices with basic
>> functionality and locking scheme.
>>  2. Radio device that translates between V4L2 subsystem requests into
>> Core device commands.
>>  3. Codec device that does similar to the earlier described task, but
>> for ALSA SoC subsystem.
>>
>> v9 of this driver has following changes:
>>    - MFD part of the driver no longer depends on the header file added
>>      by the radio driver(media/si476x.h) which should potential
>>      restore the bisectability of the patches
> I applied all the MFD patches from this patchset (All 4 first ones), plus a
> follow up one for fixing the i2c related warning.
> I also squashed the REGMAP_I2C dependency into patch #4.
> It's all in mfd-next now, I'd appreciate if you could double check it's all
> fine.
>
> Mauro will take the rest, we made sure there won't be any merge conflict
> between our trees.
>

Thanks, I will try to test it today or tomorrow(20/04) at the latest.

> Cheers,
> Samuel.
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
