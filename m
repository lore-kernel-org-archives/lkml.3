Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbbAIX5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 18:57:33 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:62739 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbbAIX5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 18:57:30 -0500
MIME-Version: 1.0
In-Reply-To: <54B05BC2.9080701@acm.org>
References: <1420663910-6406-1-git-send-email-john.stultz@linaro.org>
	<1420669469-3218-1-git-send-email-john.stultz@linaro.org>
	<54B05BC2.9080701@acm.org>
Date: Fri, 9 Jan 2015 15:57:29 -0800
Message-ID: <CALAqxLWFG+tb3Fbia0c7YfUe0xksdi0mcAvqgJH8SHOL=bMm=g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ipmi: Cleanup DEBUG_TIMING ifdef usage
From: John Stultz <john.stultz@linaro.org>
To: Corey Minyard <minyard@acm.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        openipmi-developer <openipmi-developer@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 2:52 PM, Corey Minyard <minyard@acm.org> wrote:
> On 01/07/2015 04:24 PM, John Stultz wrote:
>> The driver uses #ifdef DEBUG_TIMING in order to conditionally print out
>> timestamped debug messages. Unfortunately it adds the ifdefs all over the
>> usage sites.
>>
>> This patch cleans it up by adding a debug_timestamp() function which
>> is compiled out if DEBUG_TIMING isn't present. This cleans up all
>> the ugly ifdefs in the function logic.
>
> Yes, this is much better.  I had looked at this recently and planned to
> do something
> with it.  Queued for 3.20, unless you need it sooner.

Nope, no rush. Just wanted to make sure it gets off my queue. :)

thanks
-john
