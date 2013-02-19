Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105Ab3BSPI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:08:26 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:37131 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933006Ab3BSPIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:08:25 -0500
Message-ID: <51239563.2050900@numascale-asia.com>
Date: Tue, 19 Feb 2013 23:08:19 +0800
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
References: <1354265060-22956-1-git-send-email-daniel@numascale-asia.com> <1354265060-22956-2-git-send-email-daniel@numascale-asia.com> <20121130171749.GB23034@liondog.tnic> <50BDC140.8060004@numascale-asia.com> <20121204160156.GH4369@liondog.tnic> <51238EDA.7060700@numascale-asia.com> <20130219145947.GK26623@pd.tnic>
In-Reply-To: <20130219145947.GK26623@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/02/2013 22:59, Borislav Petkov wrote:
> On Tue, Feb 19, 2013 at 10:40:26PM +0800, Daniel J Blueman wrote:
>> Alas your merges missed the v3.8 merge window, but it looks like your
>> v3.9 pull request has dropped these patches [1].
>>
>> Any chance you can get them in during this merge window?
>
> They should go in anytime now. They're in tip:x86/platform and Ingo is
> sending pull requests to Linus as we speak. Since they touch x86 code I
> asked x86 guys to send them upstream instead of me.

Superb; thanks for your help Boris and Ingo!

Daniel
-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia
