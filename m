Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3F0PjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:39:03 -0400
Received: from dkim2.fusionio.com ([66.114.96.54]:51364 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab3F0PjA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:39:00 -0400
X-ASG-Debug-ID: 1372347539-0421b50221949b0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Dave Jones <davej@redhat.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130627151922.GA1438@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
References: <20130627145824.GA21540@redhat.com>
 <20130627150130.14981.39849@localhost.localdomain>
 <20130627151922.GA1438@redhat.com>
Message-ID: <20130627153857.14981.14731@localhost.localdomain>
User-Agent: alot/0.3.4
Subject: Re: btrfs triggered lockdep WARN.
Date: Thu, 27 Jun 2013 11:38:57 -0400
X-ASG-Orig-Subj: Re: btrfs triggered lockdep WARN.
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas2.int.fusionio.com[10.101.1.41]
X-Barracuda-Start-Time: 1372347539
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.135126
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Jones (2013-06-27 11:19:22)
> On Thu, Jun 27, 2013 at 11:01:30AM -0400, Chris Mason wrote:
>  > Quoting Dave Jones (2013-06-27 10:58:24)
>  > > Another bug caused by this script. https://github.com/kernelslacker/io-tests/blob/master/setup.sh
>  > 
>  > I'm still struggling to reproduce that one here.  I've tried every
>  > variation I can think of but I'll try again.
>  
> Note that this is a different trace to the other post about that script.

Yeah, but I haven't hit anything unusual at all yet.

> 
>  > I really hope you don't already have CONFIG_DEBUG_PAGE_ALLOC turned on,
>  > maybe it will catch this?
> 
> I do. Though given this is lockdep complaining about what looks like
> memory corruption, it's probably not related.

Ok, could you please try this with some heavy memory pressure?  I'm
hoping to trigger a use-after-free that points us in the right
direction.

-chris

