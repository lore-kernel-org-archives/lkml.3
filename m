Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbaLUMLg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 07:11:36 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:44633 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaLUMLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 07:11:34 -0500
Date: Sun, 21 Dec 2014 04:11:22 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Drysdale <drysdale@google.com>
Subject: Re: Linux 3.19-rc1 - merge window closed
Message-ID: <20141221121122.GA16310@roeck-us.net>
References: <CA+55aFwu19GP5vHTwadX+ygAKwOqNLuEBA9TVEdnfxgvzP1zHA@mail.gmail.com>
 <1419145899.8696.5.camel@haakon3.risingtidesystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1419145899.8696.5.camel@haakon3.risingtidesystems.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.5496B8F5.0149,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 11:11:39PM -0800, Nicholas A. Bellinger wrote:
> Hi Linus,
> 
> On Sat, 2014-12-20 at 17:43 -0800, Linus Torvalds wrote:
> > So it's been a day less than two weeks, and the merge window is closed.
> > 
... 
> 
> Just hit the following build failure with CONFIG_AUDIT=y:
> 
> arch/x86/ia32/audit.c: In function ‘ia32_classify_syscall’:
> arch/x86/ia32/audit.c:38:7: error: ‘__NR_execveat’ undeclared (first use in this function)
> arch/x86/ia32/audit.c:38:7: note: each undeclared identifier is reported only once for each function it appears in
> make[2]: *** [arch/x86/ia32/audit.o] Error 1
> make[1]: *** [arch/x86/ia32] Error 2
> make: *** [arch/x86] Error 2
> make: *** Waiting for unfinished jobs....
> 

I tried your configuration. For some reason it builds for me, so I guess
I must be missing something. What is your build command line ?

Thanks,
Guenter
