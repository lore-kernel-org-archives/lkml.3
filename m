Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaG0H1Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 03:27:25 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:54039 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaG0H1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 03:27:24 -0400
Date: Sun, 27 Jul 2014 00:27:22 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrew Duggan <aduggan@synaptics.com>
Cc: Christopher Heiny <cheiny@synaptics.com>, linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: synaptics-rmi4 - fix compiler warnings in F11
Message-ID: <20140727072722.GB15556@core.coreip.homeip.net>
References: <20140723061130.GA22639@core.coreip.homeip.net>
 <53D0644F.608@synaptics.com>
 <53D167A9.3020402@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D167A9.3020402@synaptics.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 01:08:09PM -0700, Andrew Duggan wrote:
> On 07/23/2014 06:41 PM, Christopher Heiny wrote:
> >On 07/22/2014 11:11 PM, Dmitry Torokhov wrote:
> >>Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> >
> >I've reviewed this, and can say:
> >
> >Acked-by: Christopher Heiny <cheiny@synaptics.com>
> >
> >but I haven't had a chance to apply it to my build tree.
> >
> >Andrew - I'll be OOO for a couple of days.  Can you do that, and
> >add a Tested-by: or rev the patch, as appropriate?
> >
> >                Thanks,
> >                    Chris
> >
> It compiles cleanly and works on my test system.
> 
> Tested-by: Andrew Duggan <aduggan@synaptics.com>

Thank you Andrew and Chris, I'll apply it to the branch then.

-- 
Dmitry
