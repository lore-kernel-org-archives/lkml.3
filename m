Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbaBROPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:15:41 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:45581 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645AbaBROPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:15:40 -0500
Message-ID: <53036B16.50305@gmail.com>
Date: Tue, 18 Feb 2014 22:15:50 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hans-Christian Egtvedt <hegtvedt@cisco.com>,
        Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: linux-next: manual merge of the tip tree with Linus' tree
References: <20140218140920.e79e5cff80dad8ecee400538@canb.auug.org.au> <20140218080603.GA27512@samfundet.no>
In-Reply-To: <20140218080603.GA27512@samfundet.no>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 04:06 PM, Hans-Christian Egtvedt wrote:
> Around Tue 18 Feb 2014 14:09:20 +1100 or thereabout, Stephen Rothwell wrote:
> 
> Hello Stephen,
> 
>> Today's linux-next merge of the tip tree got a conflict in
>> arch/avr32/include/asm/Kbuild between commit d7668f9d448a ("avr32: add
>> generic vga.h to Kbuild") from the  tree and commit b119fa61d440
>> ("locking/mcs: Order the header files in Kbuild of each architecture in
>> alphabetical order") from the tip tree.
>>
>> I fixed it up (see below) and can carry the fix as necessary (no action
>> is required).
> 
> Thank you for handling the merge.
> 
> PS! I typically don't use my Cisco address for avr32 related kernel patches,
> but it seems to be my own fault, my global gitconfig contained my @cisco.com
> address. Fixed now.
> 

Thank all of your work (also include another 2 patches).

And I guess, in the next month, I shall/can have more free time for
upstream open source, so I will/should finish avr32 allmodconfig within
next month (2014-03-31).


Thanks.
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
