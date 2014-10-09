Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbaJIVrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:47:19 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:56251 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812AbaJIVrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:47:13 -0400
Date: Fri, 10 Oct 2014 00:47:06 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Rabin Vincent <rabin@rab.in>
Cc: Felipe Balbi <balbi@ti.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, josh@joshtriplett.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: RCU bug with v3.17-rc3 ?
Message-ID: <20141009214706.GC4606@drone.musicnaut.iki.fi>
References: <20140904191642.GJ5001@linux.vnet.ibm.com>
 <20140904192535.GJ13421@saruman.home>
 <20140904200403.GL13421@saruman.home>
 <20140905213216.GD5001@linux.vnet.ibm.com>
 <20141008171322.GH22688@saruman>
 <20141008175707.GI22688@saruman>
 <20141008212938.GP22688@saruman>
 <20141009160138.GA2396@cmpxchg.org>
 <20141009162656.GE16002@saruman>
 <20141009204101.GA25955@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009204101.GA25955@debian>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 09, 2014 at 10:41:01PM +0200, Rabin Vincent wrote:
>   What GCC version are you using?
>   
>   4.8.1 and 4.8.2 are known to miscompile the ARM kernel and these
>   find_get_entry() crashes with 0xffffffff involved smell a lot like the
>   earlier reports from kernels build with those compilers:
>   
>   https://lkml.org/lkml/2014/6/25/456
>   https://lkml.org/lkml/2014/6/30/375
>   https://lkml.org/lkml/2014/6/30/660
>   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58854
>   https://lkml.org/lkml/2014/5/9/330

Is it possible to blacklist those GCC versions on ARM somehow as it
seems people are still using them?

This bug also ruined a file system on one of my boxes last year
(see e.g. http://marc.info/?l=linux-arm-kernel&m=139033442527244&w=2).

A.
