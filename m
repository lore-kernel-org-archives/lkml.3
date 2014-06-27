Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaF0VHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 17:07:39 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:64980 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaF0VHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 17:07:38 -0400
MIME-Version: 1.0
In-Reply-To: <10478237.uzP5dpN2Ri@grover>
References: <1932549.XoogLcbv2o@grover>
	<10478237.uzP5dpN2Ri@grover>
Date: Fri, 27 Jun 2014 17:07:37 -0400
Message-ID: <CADnq5_OVab=8sjo-8GBC2JOvzbz7xsHw4v=QpHdf8DwLcZhviQ@mail.gmail.com>
Subject: Re: [PANIC] at drivers/drm/drm_irq.c:976 with 3.16-rc2+git
From: Alex Deucher <alexdeucher@gmail.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 11:32 AM, Ed Tomlinson <edt@aei.ca> wrote:
> Hi
>
>
>
> It seems the follow on message with the panic's as an attachment did not
> make it.
>
> Here is a link with the jpg:
>

Preliminary fixes and discussion here:
http://lists.freedesktop.org/archives/dri-devel/2014-June/062411.html

https://bugzilla.kernel.org/show_bug.cgi?id=79051

Alex

>
>
> https://plus.google.com/u/0/photos/108244876431105742323/albums/6029631260384977873/6029631269719723986?pid=6029631269719723986&oid=108244876431105742323
>
>
>
> Thanks
>
> Ed
>
>
>
> On Friday 27 June 2014 09:17:08 Ed Tomlinson wrote:
>
>> Hi
>
>>
>
>> Got the following panic runing 16-rc2 + git. The latest commit was:
>
>>
>
>> commit d91d66e88ea95b6dd21958834414009614385153
>
>> Merge: 07f4695 6663a4f
>
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>
>> Date: Wed Jun 25 05:44:17 2014 -0700
>
>>
>
>> I was not doing anything interesting (displaying a photo from facebook
>> with firefox)
>
>> when this happened. The distribution is arch at is up to date as of june
>> 26th.
>
>>
>
>> Thanks
>
>> Ed Tomlinson
>
>
>
>
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
