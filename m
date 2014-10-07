Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbaJGU4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 16:56:07 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:43261 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbaJGU4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 16:56:05 -0400
Date: Tue, 7 Oct 2014 23:56:02 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.17
In-Reply-To: <alpine.LRH.2.11.1410072337230.7472@adalberg.ut.ee>
Message-ID: <alpine.LRH.2.11.1410072345330.7472@adalberg.ut.ee>
References: <alpine.LRH.2.11.1410072337230.7472@adalberg.ut.ee>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2014, Meelis Roos wrote:

> > Anyway, back to 3.17. Nothing major happened during the last week, as
> > you can see from the appended shortlog. Mostly drivers (i915, nouveau,
> > ethernet, scsi, sound) and some networking fixes.  With some misc
> > noise all over.
> > 
> > Go out and test,
> 
> Unfortunately my computer still livelocks with watchdog timeouts. The
> previous reports are here: https://lkml.org/lkml/2014/9/28/40 and
> https://lkml.org/lkml/2014/9/30/217 and this time the dmesg is like that 
> (config is also below):

And the other machine mentioned in the original thread at 
https://lkml.org/lkml/2014/9/28/148 is also still hanging - today a hard 
hang after half a day dekstop workload with nothing in the logs but 918 
bytes of zeros between last log record and next startup message 
(probably just ext4 artifact).

-- 
Meelis Roos (mroos@linux.ee)
