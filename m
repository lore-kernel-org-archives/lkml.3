Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaADHbv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 02:31:51 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:35122 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaADHbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 02:31:50 -0500
Date: Sat, 4 Jan 2014 07:31:43 +0000
From: Minchan Kim <minchan@kernel.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Dave Hansen <dave@sr71.net>, Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kmpark@infradead.org>, linux-mm@kvack.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHv3 00/11] Intermix Lowmem and vmalloc
Message-ID: <20140104073143.GA5594@gmail.com>
References: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
 <52C70024.1060605@sr71.net>
 <52C734F4.5020602@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C734F4.5020602@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 03, 2014 at 02:08:52PM -0800, Laura Abbott wrote:
> On 1/3/2014 10:23 AM, Dave Hansen wrote:
> >On 01/02/2014 01:53 PM, Laura Abbott wrote:
> >>The goal here is to allow as much lowmem to be mapped as if the block of memory
> >>was not reserved from the physical lowmem region. Previously, we had been
> >>hacking up the direct virt <-> phys translation to ignore a large region of
> >>memory. This did not scale for multiple holes of memory however.
> >
> >How much lowmem do these holes end up eating up in practice, ballpark?
> >I'm curious how painful this is going to get.
> >
> 
> In total, the worst case can be close to 100M with an average case
> around 70M-80M. The split and number of holes vary with the layout
> but end up with 60M-80M one hole and the rest in the other.

One more thing I'd like to know is how bad direct virt <->phys tranlsation
in scale POV and how often virt<->phys tranlsation is called in your worload
so what's the gain from this patch?

Thanks.

