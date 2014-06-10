Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaFJJIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:08:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaFJJIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:08:20 -0400
Date: Tue, 10 Jun 2014 11:08:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alexander Holler <holler@ahsoftware.de>
cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: HID: hid-sensor-hub: fix sleeping function called from invalid
 context
In-Reply-To: <5396BF5E.7070805@ahsoftware.de>
Message-ID: <alpine.LNX.2.00.1406101107360.9378@pobox.suse.cz>
References: <53963364.4010104@ahsoftware.de> <alpine.LNX.2.00.1406100038150.2827@pobox.suse.cz> <5396BF5E.7070805@ahsoftware.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Alexander Holler wrote:

> >> Looking at the differences, I wonder if not all spin_lock() calls in 
> >> hid-sensor-hub.c should be changed into spin_lock_irqsave() like the 
> >> patch from Jiri Kosina did.
> > 
> > Could you please give me your Tested-by:? I'll then be happily queuing the 
> > fix. Thanks.
> 
> Sure, but I already did that in the reply to your patch.

I probably missed in all the other noise in that thread. I've now pushed 
out the staged patch and will be pushing it to Linus for 3.16 still. 
Thanks,

-- 
Jiri Kosina
SUSE Labs
