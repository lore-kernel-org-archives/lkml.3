Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967070AbaFROWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:22:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46515 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S967046AbaFROWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:22:35 -0400
Date: Wed, 18 Jun 2014 10:22:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mina86@mina86.com>
cc: "Yang,Wei" <Wei.Yang@windriver.com>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB:gadget: Fix a warning while loading g_mass_storage
In-Reply-To: <xa1t7g4ev3uv.fsf@mina86.com>
Message-ID: <Pine.LNX.4.44L0.1406181021400.1467-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Michal Nazarewicz wrote:

> On Wed, Jun 18 2014, Yang,Wei wrote:
> > On 06/17/2014 10:18 PM, Alan Stern wrote:
> >> That is a strange question to ask.  If you did not know that I approved
> >> the patch, why did you insert my Acked-By:?
> 
> > I added your Acked-By, as when you reviewed V3, you mentioned that I 
> > *may* add your Acked-by in this patch. If I misunderstood your point, I 
> > am so sorry for that.
> 
> Alan's point is that if you have any doubts whether someone approves
> your patch you should *not* add their Acked-by.  So adding someone's
> Acked-by and then asking if they are fine with the patch is
> contradictory -- the former indicates that you believe the person is
> fine with the patch, while the latter shows that you aren't.
> 
> Alan wrote:
> 
> >>> With that change, you may add
> >>>
> >>> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 
> so after adding “that change” you are in your right to add Alan's
> Acked-by, but what that also means is that Alan will be fine with the
> patch if you make the requested change, so you don't need to ask for an
> opinion again.
> 
> PS. Note that “having any doubts” also means that if someone gave you
>     their Acked-by, but then you substantially rewrite the patch, you
>     probably should consider removing their Acked-by.

Exactly so.

Alan Stern

