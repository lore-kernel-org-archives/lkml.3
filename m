Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaBSDM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 22:12:27 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:35297 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbaBSDMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 22:12:24 -0500
MIME-Version: 1.0
In-Reply-To: <CAK9yfHyCs+GSD1i25u-8aJ49kBQkRLbWvsupSpQAD=6=W66vdA@mail.gmail.com>
References: <1392722606-965-1-git-send-email-sj38.park@gmail.com>
 <20140218170753.GB32227@kroah.com> <CAEjAshp3HQq6L1opWJX=dnwQ=SqScb4s2gdLiehC8ejaFV7eOQ@mail.gmail.com>
 <CAK9yfHyCs+GSD1i25u-8aJ49kBQkRLbWvsupSpQAD=6=W66vdA@mail.gmail.com>
From: SeongJae Park <sj38.park@gmail.com>
Date: Wed, 19 Feb 2014 12:11:53 +0900
Message-ID: <CAEjAshp2XE41idFaSgPtjHVj604QKJFfqydJtnJOu7grZhWLKQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging: android: binder: remove unnecessary comment
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Brian Swetland <swetland@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 12:04 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> On 19 February 2014 05:58, SeongJae Park <sj38.park@gmail.com> wrote:
>> On Wed, Feb 19, 2014 at 2:07 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>> On Tue, Feb 18, 2014 at 08:23:25PM +0900, SeongJae Park wrote:
>>>> Signed-off-by: SeongJae Park <sj38.park@gmail.com>
>>>> ---
>>>>  drivers/staging/android/binder.c | 2 --
>>>>  1 file changed, 2 deletions(-)
>>>>
>>>> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
>>>> index eaec1da..b23cbc9 100644
>>>> --- a/drivers/staging/android/binder.c
>>>> +++ b/drivers/staging/android/binder.c
>>>> @@ -2553,8 +2553,6 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>>>>       unsigned int size = _IOC_SIZE(cmd);
>>>>       void __user *ubuf = (void __user *)arg;
>>>>
>>>> -     /*pr_info("binder_ioctl: %d:%d %x %lx\n", proc->pid, current->pid, cmd, arg);*/
>>>
>>> It's useful for debugging, I'll leave it as-is, sorry.
>
> Or just convert pr_info to pr_debug and leave uncommented?

Sounds much better. Thank you for suggestion.
I will send patch with your recommend again soon.

>
> --
> With warm regards,
> Sachin
