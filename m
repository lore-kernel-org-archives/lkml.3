Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164AbaFIWkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:40:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415AbaFIWki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:40:38 -0400
Date: Tue, 10 Jun 2014 00:40:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alexander Holler <holler@ahsoftware.de>
cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: HID: hid-sensor-hub: fix sleeping function called from invalid
 context
In-Reply-To: <53963364.4010104@ahsoftware.de>
Message-ID: <alpine.LNX.2.00.1406100038150.2827@pobox.suse.cz>
References: <53963364.4010104@ahsoftware.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Alexander Holler wrote:

> Hello,
> 
> while rebasing the dozens (currently around 60) of refused, ignored or
> similiar bugfixes and patches I need to use a Linux kernel, I've noticed that
> Jiri Kosinas patch here
> 
> https://lkml.org/lkml/2013/8/9/214
> 
> doesn't apply anymore.
> 
> Looking why, I've seen that a similiar patch from Srinivas Pandruvada named
> like the topic ended up in the kernel.

Hi Alexander,

thanks for drawing this one from the boulevard of forgotten patches.

I am actually not aware of any patch by Srinivas that would conflict with 
the one I've written -- could you please elaborate where you believe the 
conflict is?

> Looking at the differences, I wonder if not all spin_lock() calls in 
> hid-sensor-hub.c should be changed into spin_lock_irqsave() like the 
> patch from Jiri Kosina did.

Could you please give me your Tested-by:? I'll then be happily queuing the 
fix. Thanks.

> (sorry for the duplicate message, I've forgotten to add the
> wanna-be-reviewer-school named lkml to the recipients)

You want to make it to LWN quotes of the week, don't you? :)

-- 
Jiri Kosina
SUSE Labs
