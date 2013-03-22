Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab3CVE74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 00:59:56 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:57266 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3CVE7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 00:59:55 -0400
Date: Thu, 21 Mar 2013 23:59:50 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] nohz1: Documentation
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
        geoff@infradead.org, tglx@linutronix.de
In-Reply-To: <514B2B03.4030301@linux.intel.com> (from arjan@linux.intel.com
	on Thu Mar 21 10:45:07 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1363928390.15703.57@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 10:45:07 AM, Arjan van de Ven wrote:
> On 3/20/2013 5:27 PM, Steven Rostedt wrote:
>> I'm not sure I would recommend idle=poll either. It would certainly
>> work, but it goes to the other extreme. You think NO_HZ=n drains a
>> battery? Try idle=poll.
> 
> 
> do not ever use idle=poll on anything production.. really bad idea.
> 
> if you temporary cannot cope with the latency, you can use the PMQOS  
> system
> to limit (including going all the way to idle=poll).
> but using idle=poll completely is very nasty for the hardware.
> 
> In addition we should document that idle=poll will cost you peak  
> performance,
> possibly quite a bit.

Where should that be documented?

> the same is true for the kernel paramter to some extend; it's there  
> to work around
> broken bioses/hardware/etc; if you have a latency/runtime  
> requirement, it's much better
> to use PMQOS for this from userspace.

I googled and found  
http://elinux.org/images/f/f9/Elc2008_pm_qos_slides.pdf

Rob