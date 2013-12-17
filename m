Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab3LQQew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:34:52 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:44045 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab3LQQeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:34:50 -0500
Message-ID: <52B07D25.4090901@linaro.org>
Date: Tue, 17 Dec 2013 08:34:45 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [RFC][PATCH 3/5] timekeeping: Avoid possible deadlock from clock_was_set_delayed
References: <1386789098-17391-1-git-send-email-john.stultz@linaro.org> <1386789098-17391-4-git-send-email-john.stultz@linaro.org> <52A9E5B2.8040702@oracle.com> <52AA014B.6000301@oracle.com> <52AA0798.1050709@linaro.org> <52AA08EB.1080703@oracle.com> <52AA0AD2.5030307@linaro.org> <52AFDDE6.2020600@linaro.org> <52AFF20F.5070202@oracle.com>
In-Reply-To: <52AFF20F.5070202@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2013 10:41 PM, Sasha Levin wrote:
> On 12/17/2013 12:15 AM, John Stultz wrote:
>>
>> Just wanted to follow up here. Did you happen to get a chance to try to
>> reproduce w/ the three patch patchset?
>>
>> I'm hoping to submit them to Ingo tomorrow, and want to make sure I've
>> got your tested-by.
>
> Oh yeah, have been running it ever since, haven't seen the issue
> reproduce.

Great! I'll add your tested-by line, if that's ok.

thanks
-john

