Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaAXL4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 06:56:34 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:64684 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaAXL4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 06:56:33 -0500
Date: Fri, 24 Jan 2014 15:56:29 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>, gnome@rvzt.net,
        alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [PATCH] mm: Ignore VM_SOFTDIRTY on VMA merging, v2
Message-ID: <20140124115629.GI1992@moon>
References: <20140122190816.GB4963@suse.de>
 <20140122191928.GQ1574@moon>
 <20140122223325.GA30637@moon>
 <20140123095541.GD4963@suse.de>
 <20140123103606.GU1574@moon>
 <20140123121555.GV1574@moon>
 <20140123125543.GW1574@moon>
 <20140123151445.GX1574@moon>
 <20140124101416.GP4963@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124101416.GP4963@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 10:14:16AM +0000, Mel Gorman wrote:
> > From: Cyrill Gorcunov <gorcunov@gmail.com>
> > Subject: [PATCH] mm: Ignore VM_SOFTDIRTY on VMA merging, v2
> > 
> 
> It passed the gimp launching test. Patch looks sane but I confess I did
> not put a whole lot of thought into it because I see that Andrew is
> already reviewing it so
> 
> Tested-by: Mel Gorman <mgorman@suse.de>
> 
> If this is merged then remember that it should be tagged for 3.12-stable
> as 3.12.7 and 3.12.8 are affected by this bug.

Thanks a huge, Mel! Andrew has picked it up and CC'ed stable@ team.
