Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaJRX5S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 19:57:18 -0400
Received: from roy.gaast.net ([80.101.33.21]:59354 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbaJRX5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 19:57:17 -0400
Message-ID: <5442FE58.5020700@gaast.net>
Date: Sun, 19 Oct 2014 00:57:12 +0100
From: Wilmer van der Gaast <wilmer@gaast.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130112 Icedove/17.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Machine crashes right *after* ~successful resume
References: <54347520.3050109@gaast.net> <543AA2FE.20105@gaast.net> <20141012204032.GA11171@amd> <9751497.0fL0kvsyX7@vostro.rjw.lan> <20141015111641.GC7792@gaast.net> <CAErSpo5A+nHTu2Y6KrXowBBCBsNw_hO0SRsnc6YRdJChCUmO6w@mail.gmail.com> <CAE9FiQV9t0bCfUy5Fichdk=04ruEVxGv-LUK1xxZjCrasAOACg@mail.gmail.com> <543F049F.5090605@gaast.net> <CAE9FiQWDHq5esSt4UvE5AkHR-=XMvrzaNFwLg+0xKisTNOtcsQ@mail.gmail.com> <543F9182.9000004@gaast.net> <CAE9FiQVNZHTxpNCnn+YPtqjWrQjFmtTh06sbBawqFonMFwSZ-w@mail.gmail.com> <544033CF.3080104@gaast.net> <CAE9FiQW0x5uy_osjvVDOOMDaz2=2KL+TusQ8QqcHL5dWTPrK2w@mail.gmail.com>
In-Reply-To: <CAE9FiQW0x5uy_osjvVDOOMDaz2=2KL+TusQ8QqcHL5dWTPrK2w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending, forgot to hit reply-to-all.)

Hello Yinghai,

On 18-10-14 22:28, Yinghai Lu wrote:
 >
 > Please apply attached debug patch on top of v3.17 and boot with
 > "debug ignore_loglevel initcall_debug no_console_suspend".
 >
 > Hope we can find out which nb notifier cause problem.
 >
Did that. Strangely, or better said, quite annoyingly, I'm now getting 
no output anymore at all on the third resume! :-(

I could try non-serial instead if you think that's worth a shot, but the 
most annoying thing is that my video doesn't get initialised properly 
after resume unless I have the tainting nvidia driver loaded. I could 
try if nouveau helps.

I've dropped all the debugging output in the same directory like before, 
look for files named like 
http://roy.gaast.net/~wilmer/.lkml/bad3.17-patched-initcall.txt


Thanks,

Wilmer v/d Gaast.

-- 
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +
