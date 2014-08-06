Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaHFU4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:56:20 -0400
Received: from senator.holtmann.net ([87.106.208.187]:33519 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbaHFU4S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:56:18 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] staging: nokia_h4: nokia_core.c: use usleep_range() instead of msleep()
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20140530163604.GA11943@kroah.com>
Date: Wed, 6 Aug 2014 13:56:33 -0700
Cc: =?iso-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Miguel Oliveira <cmroliv@gmail.com>,
        gulsah.1004@gmail.com, peter.p.waskiewicz.jr@intel.com,
        kristina.martsenko@gmail.com, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <DB71A450-EF1D-479F-9111-A36FF8EA89B2@holtmann.org>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com> <20140530123023.GA10549@amd.pavel.ucw.cz> <20140530155959.GA10682@kroah.com> <201405301815.10811@pali> <20140530163604.GA11943@kroah.com>
To: Greg KH <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

>>>>>>> Creating this patch for the Eudyptula Challenge.
>>>>>>> Replaced msleep() for a delay < 20ms with a
>>>>>>> usleep_range() between 10000us and 15000us. Also
>>>>>>> inserted a blank line after adeclaration.
>>>>>> 
>>>>>> So you are changing timings without testing. Plus,
>>>>>> burning CPU power instead of sleeping.
>>>>>> 
>>>>>> Seems you'll need another patch for the challenge :-).
>>>>> 
>>>>> I actually wonder if anybody is seriously working on this
>>>>> driver. My concern with the staging drivers has always
>>>>> been that we are quick with merging them when the work on
>>>>> getting them into upstream shape is actually hard.
>>>>> However reality is once they are in staging nobody is
>>>>> doing the work to clean them up and fix the issues.
>>>> 
>>>> There is active work on merging n900 changes.
>>> 
>>> Really?  Where?
>>> 
>> 
>> You can look at elinux wiki where is table how process is going:
>> http://elinux.org/N900
>> 
>> Also look at planed future list and its progress:
>> http://elinux.org/N900/Changelog
>> 
>> You can see that drivers are including step by step.
> 
> I'm not going to dig through random web pages, sorry.  If patches aren't
> sent to me for a driver, I consider it dead, that's only fair for me
> given my workload, don't you think?
> 
>>>> And no, it does not progress as quickly as I'd like, but
>>>> we'll get there. It is also requirement for n900 FM radio
>>>> receiving...
>>>> 
>>>>> Greg, instead of wasting our time with this, can we just
>>>>> remove this driver from staging.
>>>> 
>>>> Please don't.
>>> 
>>> As there has not been any real work on it since it has been
>>> merged, I don't see why I shouldn't remove it.  If you do get
>>> some work done on it, you can always revert the removal and
>>> continue on.  But the existance of code in staging that is
>>> not progressing forward at all is something that I don't like
>>> at all, and will be doing a large sweep of soon to remove.
>>> 
>>> thanks,
>>> 
>>> greg k-h
>> 
>> Just look how much time took to include my patch for radio-
>> bcm2048 (fm radio part of this chip) which fixing wrong overflow 
>> check. I sent it at the end of December and... yes it is still 
>> not included in linus tree. Now it is somethere in media tree and 
>> probably will be pulled in next merge window.
>> 
>> This means that it takes about half of year to include patches 
>> for these drivers.
> 
> Just because the media drivers take a long time to get fixes merged,
> don't use that as an excuse to not fix up the staging drivers.
> 
> In fact, it sounds like you have lots of time while that patch is
> getting merged, why not work on fixing up the staging driver?  :)

and 2 month later, we still have nothing accomplished with this driver.

So this driver is 6 month in staging and not a single commit to address anything in the TODO file. I only see pointless coding style change.

There is a reason why I dislike staging drivers. And this is exactly it. It gets treated as dumping ground. So can we please remove this driver now. Maybe someone finally wakes up and does their promised job.

Regards

Marcel

