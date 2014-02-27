Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaB0LaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:30:09 -0500
Received: from mail.wdtv.com ([66.118.69.84]:47511 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbaB0LaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:30:07 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Mike Galbraith <bitbucket@online.de>
Subject: Re: 3.13.5 : rm -rf running forever, one cpu at approx 100%
Date: Thu, 27 Feb 2014 06:30:04 -0500
Cc: Ken Moffat <zarniwhoop@ntlworld.com>, linux-kernel@vger.kernel.org
References: <20140227005246.GB10367@milliways> <20140227034535.GC14346@milliways> <1393476762.5519.35.camel@marge.simpson.net>
In-Reply-To: <1393476762.5519.35.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201402270630.05236.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 February 2014, Mike Galbraith wrote:
>On Thu, 2014-02-27 at 03:45 +0000, Ken Moffat wrote:
>> On Thu, Feb 27, 2014 at 04:26:35AM +0100, Mike Galbraith wrote:
>> > I would start with strace to see if a task is looping in userspace,
>> > then move on to perf top -g -p <pid> (or perf record/report) to peek
>> > at what it's up to in the kernel.  Once you have the where,
>> > trace_printk() is the best thing since sliced bread (which ranks
>> > just below printk()).
>> > 
>> > -Mike
>>  
>>  Thanks.  I'll need to build perf.
>
>You may want to build the kernel with frame-pointers too, for easy gdb
>list *0x(hexnum) of *func()+0x(hexoffset) use.  Crash is also pretty
>handy both for rummaging live via crash vmlinux /proc/kcore, and for
>leisurely postmortem analysis if you set the box up to crashdump in
>advance, and force a dump (poke sysrq-c or echo c > /proc/sysrq-trigger)
>when you see the bad thing happen.  Crash has all kinds of goodies,
>including invocation of gdb.
>
>-Mike

It doesn't look as if I'll have to guys.  Amanda is about 1/2 done and 
running normally by switching from tar-1.22 to tar-1.27.  So I'm going to 
toddle off in the general direction of a bed and let amanda send me an 
email when its done.

And it did, including some "strange" reports I have yet to decipher. Diffs 
in the tar's probably.  But it did not hang.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.

