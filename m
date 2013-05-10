Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab3EJIoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:44:18 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:63808 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab3EJIoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:44:16 -0400
X-AuditID: 9c930197-b7c1fae000001854-ac-518cb35de685
Date: Fri, 10 May 2013 17:44:13 +0900
From: Minchan Kim <minchan@kernel.org>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>, Shaohua Li <shli@kernel.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: [PATCH v3] mm: remove compressed copy from zram in-memory
Message-ID: <20130510084413.GA2683@blaptop>
References: <1368056517-31065-1-git-send-email-minchan@kernel.org>
 <20130509201540.GB5273@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130509201540.GB5273@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

On Thu, May 09, 2013 at 04:15:42PM -0400, Konrad Rzeszutek Wilk wrote:
> On Thu, May 09, 2013 at 08:41:57AM +0900, Minchan Kim wrote:
> 
> Hey Michan,
        ^-n

It's a only thing I can know better than other native speakers. :)

 
> Just a couple of syntax corrections. The code comment could also
> benefit from this.
> 
> Otherwise it looks OK to me.
> 
> > Swap subsystem does lazy swap slot free with expecting the page
>                      ^-a                       ^- the expectation that
> > would be swapped out again so we can avoid unnecessary write.
>                                 ^--that it
> > 
> > But the problem in in-memory swap(ex, zram) is that it consumes
>                   ^^-with
> > memory space until vm_swap_full(ie, used half of all of swap device)
> > condition meet. It could be bad if we use multiple swap device,
>            ^- 'is'   ^^^^^ - 'would'                       ^^^^^-devices                    
> > small in-memory swap and big storage swap or in-memory swap alone.
>                       ^-,                   ^-,
> > 
> > This patch makes swap subsystem free swap slot as soon as swap-read
> > is completed and make the swapcache page dirty so the page should
>                        ^-makes                      ^-'that the'
> > be written out the swap device to reclaim it.
> > It means we never lose it.
> > 
> > I tested this patch with kernel compile workload.
>                           ^-a

Thanks for the correct whole sentence!
But Andrew alreay correted it with his style.
Although he was done, I'm giving a million thanks to you.
Surely, Thanks Andrew, too.

-- 
Kind regards,
Minchan Kim
