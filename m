Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984Ab3BSOkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 09:40:33 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:40813 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877Ab3BSOkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 09:40:32 -0500
Message-ID: <51238EDA.7060700@numascale-asia.com>
Date: Tue, 19 Feb 2013 22:40:26 +0800
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4 v8] AMD64 EDAC: Fix type usage in NB IDs and memory
 ranges
References: <1354265060-22956-1-git-send-email-daniel@numascale-asia.com> <1354265060-22956-2-git-send-email-daniel@numascale-asia.com> <20121130171749.GB23034@liondog.tnic> <50BDC140.8060004@numascale-asia.com> <20121204160156.GH4369@liondog.tnic>
In-Reply-To: <20121204160156.GH4369@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On 05/12/2012 00:01, Borislav Petkov wrote:
> On Tue, Dec 04, 2012 at 05:24:16PM +0800, Daniel J Blueman wrote:
>> It works well on fam10h and fam15h boxes, with and without Numaconnect.
>
> Good, thanks for testing.
>
> I will send it upstream after the upcoming merge window closes since it
> is too late for this one now and I wouldn't want to rush it if it is not
> necessary to do so and it hasn't seen enough testing in linux-next and
> -tip trees. Which means that it will end up in 3.9; I hope that is OK
> with you guys.

Alas your merges missed the v3.8 merge window, but it looks like your 
v3.9 pull request has dropped these patches [1].

Any chance you can get them in during this merge window?

Many thanks,
   Daniel

[1] 
https://groups.google.com/forum/?fromgroups=#!topic/linux.kernel/2DLVw1Rv8bQ
-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia
