Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbaKUCQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 21:16:14 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:36556 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371AbaKUCQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 21:16:13 -0500
X-Original-SENDERIP: 165.186.175.61
X-Original-MAILFROM: ciogenis@gmail.com
Date: Fri, 21 Nov 2014 11:10:39 +0900
From: Hyogi Gim <ciogenis@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: a.zummo@towertech.it, john.stultz@linaro.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/rtc/interface.c: check the validation of
 rtc_time in __rtc_read_time
Message-ID: <20141121021039.GB8368@lge.com>
References: <20141008020529.GA21464@lge.com>
 <20141014152131.1442b937e3010a558c7798a6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141014152131.1442b937e3010a558c7798a6@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 03:21:31PM -0700, Andrew Morton wrote:
> On Wed, 8 Oct 2014 11:05:29 +0900 Hyogi Gim <ciogenis@gmail.com> wrote:
> 
> > Some of rtc devices always return '0' when rtc_class_ops.read_time is called.
> > So if rtc_time isn't verified in callback, rtc interface cannot know whether
> > rtc_time is valid.
> 
> We should fix the buggy .read_time() implementations...
> 

Thanks for comments.
I'm studying rtc framework and trying to find a problem.
This is a minor bug. But, as you know, it can be a big problem for
newbies like me.

Even though it was late, I send you reply because a question.
If this patch is merged, rtc_valid_tm() in rtc_class_ops.read_time
callback is not necessary anymore.
So, I think each rtc device driver should change the code.
I can change the code. But, test is a little different.

In this case, how can I progress this modification?
Can I just send the notification for rtc_valid_tm() to the driver
manufacturer? or, request test for the code that I've modified?

-- 
Hyogi

