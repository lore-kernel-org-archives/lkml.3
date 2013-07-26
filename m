Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab3GZT0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 15:26:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:57084 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab3GZT0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 15:26:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,752,1367996400"; 
   d="scan'208";a="273870258"
Date: Fri, 26 Jul 2013 12:26:09 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Heinz Diehl <htd@fritha.org>
Cc: Frantisek Hrbata <fhrbata@redhat.com>, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        dzickus@redhat.com, kernel-team@fedoraproject.org
Subject: Re: NULL pointer dereference in xhci_free_dev
Message-ID: <20130726192609.GC15302@xanatos>
References: <20130507140333.GB3380@dhcp-26-164.brq.redhat.com>
 <20130509221559.GD10305@xanatos>
 <20130510065644.GA3320@dhcp-26-164.brq.redhat.com>
 <20130511140925.GA9240@fritha.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130511140925.GA9240@fritha.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heinz and Frantisek,

I believe your issue should be fixed by this patch:

http://marc.info/?l=linux-usb&m=137476546506888&w=2

Please let me know if it doesn't.

Sarah Sharp

On Sat, May 11, 2013 at 04:09:25PM +0200, Heinz Diehl wrote:
> On 11.05.2013, Frantisek Hrbata wrote: 
> 
> > I haven't tried to reproduce. I was asked to help with Fedora's bugs triage and
> > these come up. The goal was just to contact the right people and bring this to
> > their attention. If you have a patch for this, I guess we can try to ask Heinz,
> > or other people reporting this problem, to help with testing.
> 
> I'm willing to help, of course. I'll try to install latest 3.9 on the
> machine this bug occurs and see if I manage to reproduce it. As far as
> I remember, it happened when I changed some USB 2.0 devices on an USB
> 3 port. The machine is re-installed and runs F18 now.
>  
> > Heinz: Sorry I forgot to add you to CC in the first mail, but Sarah fixed it.
> 
> Never mind, I'm subscribed to lkml and saw the thread there ;-)
> 
