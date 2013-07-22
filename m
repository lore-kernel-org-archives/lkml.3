Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432Ab3GVVQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:16:01 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:51392 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932758Ab3GVVQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:16:00 -0400
Message-ID: <51EDA10D.6040207@linaro.org>
Date: Mon, 22 Jul 2013 14:15:57 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] RTC: Add an alarm disable quirk
References: <1374162294-29726-1-git-send-email-bp@alien8.de> <51E8194E.1030704@linaro.org> <20130718225349.GD15992@pd.tnic> <20130719142628.GC19581@pd.tnic> <20130719151321.GD19581@pd.tnic> <51ED9D15.3010304@linaro.org> <20130722211223.GC4613@pd.tnic>
In-Reply-To: <20130722211223.GC4613@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 02:12 PM, Borislav Petkov wrote:
> On Mon, Jul 22, 2013 at 01:59:01PM -0700, John Stultz wrote:
>> So did this work some of the time, but not all? Or was the behavior
>> totally unchanged with this?
> Yep, some of the time. The first couple of runs it worked and I was
> euphoric and then it rebooted and I almost threw the box out the window
> :-)

I can understand your frustration. :)

But its interesting it sort of worked, no?  The bit you discovered 
earlier with the dump_stack debugging call, where we're actually 
disabling the irq twice was interesting.

If you use the debugging patch with this change, does it show any 
different in logic between the working cases and the instant-reboot case?

thanks
-john

