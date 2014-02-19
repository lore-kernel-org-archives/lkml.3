Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaBSDE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 22:04:59 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:43825 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaBSDE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 22:04:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAEjAshp3HQq6L1opWJX=dnwQ=SqScb4s2gdLiehC8ejaFV7eOQ@mail.gmail.com>
References: <1392722606-965-1-git-send-email-sj38.park@gmail.com>
	<20140218170753.GB32227@kroah.com>
	<CAEjAshp3HQq6L1opWJX=dnwQ=SqScb4s2gdLiehC8ejaFV7eOQ@mail.gmail.com>
Date: Wed, 19 Feb 2014 08:34:57 +0530
Message-ID: <CAK9yfHyCs+GSD1i25u-8aJ49kBQkRLbWvsupSpQAD=6=W66vdA@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging: android: binder: remove unnecessary comment
From: Sachin Kamat <sachin.kamat@linaro.org>
To: SeongJae Park <sj38.park@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Brian Swetland <swetland@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 February 2014 05:58, SeongJae Park <sj38.park@gmail.com> wrote:
> On Wed, Feb 19, 2014 at 2:07 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Tue, Feb 18, 2014 at 08:23:25PM +0900, SeongJae Park wrote:
>>> Signed-off-by: SeongJae Park <sj38.park@gmail.com>
>>> ---
>>>  drivers/staging/android/binder.c | 2 --
>>>  1 file changed, 2 deletions(-)
>>>
>>> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
>>> index eaec1da..b23cbc9 100644
>>> --- a/drivers/staging/android/binder.c
>>> +++ b/drivers/staging/android/binder.c
>>> @@ -2553,8 +2553,6 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>>>       unsigned int size = _IOC_SIZE(cmd);
>>>       void __user *ubuf = (void __user *)arg;
>>>
>>> -     /*pr_info("binder_ioctl: %d:%d %x %lx\n", proc->pid, current->pid, cmd, arg);*/
>>
>> It's useful for debugging, I'll leave it as-is, sorry.

Or just convert pr_info to pr_debug and leave uncommented?

-- 
With warm regards,
Sachin
