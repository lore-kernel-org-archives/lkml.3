Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaAXOXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 09:23:09 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:40099 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbaAXOXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 09:23:07 -0500
Date: Fri, 24 Jan 2014 18:23:03 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>, gnome@rvzt.net,
        alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [PATCH] mm: Ignore VM_SOFTDIRTY on VMA merging, v2
Message-ID: <20140124142303.GJ1992@moon>
References: <20140122191928.GQ1574@moon>
 <20140122223325.GA30637@moon>
 <20140123095541.GD4963@suse.de>
 <20140123103606.GU1574@moon>
 <20140123121555.GV1574@moon>
 <20140123125543.GW1574@moon>
 <20140123151445.GX1574@moon>
 <20140124101416.GP4963@suse.de>
 <20140124115629.GI1992@moon>
 <20140124134135.GW4963@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124134135.GW4963@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 01:41:35PM +0000, Mel Gorman wrote:
> > 
> > Thanks a huge, Mel! Andrew has picked it up and CC'ed stable@ team.
> 
> Big thanks to the gimp developers that actually pinned this down as a
> kernel bug and the people who shoved it through the kernel bugzilla. I
> just did a light bit of legwork shuffling the paperwork around :P

Sure! The help in testing and finding kernel problem is always invaluable!
