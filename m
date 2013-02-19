Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934792Ab3BSWdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 17:33:47 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33119 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933911Ab3BSWdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 17:33:46 -0500
Date: Tue, 19 Feb 2013 22:33:32 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm: Allow arch code to control the user page table
 ceiling
Message-ID: <20130219223330.GA6889@MacBook-Pro.local>
References: <1361204311-14127-1-git-send-email-catalin.marinas@arm.com>
 <1361204311-14127-2-git-send-email-catalin.marinas@arm.com>
 <alpine.LNX.2.00.1302191005320.2139@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1302191005320.2139@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 06:08:12PM +0000, Hugh Dickins wrote:
> On Mon, 18 Feb 2013, Catalin Marinas wrote:
> 
> > From: Hugh Dickins <hughd@google.com>
> 
> You're being generous to me :)

OTOH, there are better chances to get the patch upstream ;)

> Thanks for doing most of the work, yes, this looks fine.
> BUt I'd have expected a Cc stable below: see comment on 2/2.

Yes, I will add cc stable. When I post patches for review I usually
avoid cc'ing stable since Git has the habit of actually sending the
email to stable@vger.kernel.org (and I want it to email the other people
on cc).

Thanks.

-- 
Catalin
