Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934484Ab3GWX4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 19:56:12 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37941 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934085Ab3GWX4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 19:56:10 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20130723234040.GB27761@codeaurora.org>
References: <20130625200211.GA11625@codeaurora.org>
	<CAOesGMj5AZcB7-kcS8_JqfKAg_RUKqTdDZf7bdwkebn3pwADAw@mail.gmail.com>
	<20130723234040.GB27761@codeaurora.org>
Date: Tue, 23 Jul 2013 16:56:09 -0700
Message-ID: <CAOesGMiornt0twdQv=tYMtAX56Lc79MVyNrHaK1nWpOk189dDA@mail.gmail.com>
Subject: Re: [GIT PULL] Remove ARM local timer API
From: Olof Johansson <olof@lixom.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>, Barry Song <baohua.song@csr.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 4:40 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 07/23, Olof Johansson wrote:

>> Merged in as localtimer/removal into next/cleanup.
>>
>> I had quite a few merge conflicts due to the __cpuinit removal, so
>> please double-check my resolutions.
>>
>
> A __cpuinit is leftover in smp_twd.c. Hopefully you can just
> redo the merge?

Done, thanks for catching it. I thought I grepped for them but I
somehow missed that one. Fixed now.


-Olof
