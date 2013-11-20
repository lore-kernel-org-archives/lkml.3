Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab3KTJoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:44:38 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:36798 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3KTJoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:44:34 -0500
Message-ID: <528C84A1.5030707@gmail.com>
Date: Wed, 20 Nov 2013 10:45:05 +0100
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
References: <20131117132531.GB27696@pd.tnic> <5288E5BF.2020608@gmail.com> <20131117160126.GG27323@pd.tnic> <CAC9WiBikz8kTAmKs1HVBmeb2Wu6hfHCh2d=w1sQC03EVHa1QOQ@mail.gmail.com> <20131117195358.GO27323@pd.tnic> <CAC9WiBggfssh+31_MqVCT-hDf2E8zTuc81q-DhLYQuVF053mEA@mail.gmail.com> <20131117220611.GQ27323@pd.tnic> <528A05D0.30907@gmail.com> <20131118133210.GG24851@pd.tnic> <528B36EA.20301@gmail.com> <20131119101521.GA3515@pd.tnic>
In-Reply-To: <20131119101521.GA3515@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Borislav,

On 11/19/2013 11:15 AM, Borislav Petkov wrote:
> On Tue, Nov 19, 2013 at 11:01:14AM +0100, Francis Moreau wrote:
>> I think the easiest way to do it is to install a minimal system on a
>> USB stick and try to reproduce first in order to preserve my system.
> 
> Yep, sounds simple enough.
> 
>> Then I'll try to see if this issue exists in a previous kernel version
>> and if so, I'll do a git-bisect session.
>>
>> I can't find a quicker way to do that although using git-bisect (which
>> implies several kernel builds) is a PITA.
> 
> You can start with a coarse bisect by testing the major kernel versions
> first, i.e. 3.11, 3.10, 3.9 ... and once you find good and bad, then you
> can do the git-bisect thing.
> 

Unfortunately the bisect session didn't give any positive results: I
couldn't be sure if a specific revision was good or bad because the bug
wasn't reproductible every time.

But I got a different kernel oops on my stripped system that may give us
a clue: http://imgur.com/zdCknbY

Does this help ?

Thanks.
