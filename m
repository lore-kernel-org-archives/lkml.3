Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab3KSKAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:00:43 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:34728 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab3KSKAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:00:42 -0500
Message-ID: <528B36EA.20301@gmail.com>
Date: Tue, 19 Nov 2013 11:01:14 +0100
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
References: <52888F6D.6000802@gmail.com> <20131117132531.GB27696@pd.tnic> <5288E5BF.2020608@gmail.com> <20131117160126.GG27323@pd.tnic> <CAC9WiBikz8kTAmKs1HVBmeb2Wu6hfHCh2d=w1sQC03EVHa1QOQ@mail.gmail.com> <20131117195358.GO27323@pd.tnic> <CAC9WiBggfssh+31_MqVCT-hDf2E8zTuc81q-DhLYQuVF053mEA@mail.gmail.com> <20131117220611.GQ27323@pd.tnic> <528A05D0.30907@gmail.com> <20131118133210.GG24851@pd.tnic>
In-Reply-To: <20131118133210.GG24851@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 02:32 PM, Borislav Petkov wrote:
> On Mon, Nov 18, 2013 at 01:19:28PM +0100, Francis Moreau wrote:
>> Just out of curiosity, running "objdump -D" doesn't seem to show the
>> same thing here. How did you get such dump with function names for
>> example ?
> 
> There's another, non-stripped vmlinux in the kernel package:
> 
> $ objdump -D usr/src/linux-3.12.0-1-ARCH/vmlinux | less
> 

oh I see, thks.

>> The thing is that I'd like to avoid to oops my kernel to avoid to
>> corrupt my filesystem.
> 
> Then debugging this thing would be very hard, if not impossible but it
> is your decision at the end of the day...
> 

This issue is really annoying so I'll try to debug it.

I think the easiest way to do it is to install a minimal system on a USB
stick and try to reproduce first in order to preserve my system.

Then I'll try to see if this issue exists in a previous kernel version
and if so, I'll do a git-bisect session.

I can't find a quicker way to do that although using git-bisect (which
implies several kernel builds) is a PITA.

Thanks.
