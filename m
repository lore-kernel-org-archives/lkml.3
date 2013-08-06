Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3HFGfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 02:35:17 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:51744 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3HFGfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 02:35:14 -0400
Message-ID: <52009908.3070609@synopsys.com>
Date: Tue, 6 Aug 2013 12:04:48 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        azurIt <azurit@pobox.sk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <x86@kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/7] arch: mm: remove obsolete init OOM protection
References: <1375549200-19110-1-git-send-email-hannes@cmpxchg.org> <1375549200-19110-2-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1375549200-19110-2-git-send-email-hannes@cmpxchg.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.186]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

Thk for the cleanup.

On 08/03/2013 10:29 PM, Johannes Weiner wrote:
> Back before smart OOM killing, when faulting tasks where killed
> directly on allocation failures, the arch-specific fault handlers
> needed special protection for the init process.
> 
> Now that all fault handlers call into the generic OOM killer (609838c
> "mm: invoke oom-killer from remaining unconverted page fault
> handlers"), which already provides init protection, the arch-specific
> leftovers can be removed.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  arch/arc/mm/fault.c   | 5 -----
>  arch/score/mm/fault.c | 6 ------
>  arch/tile/mm/fault.c  | 6 ------
>  3 files changed, 17 deletions(-)

Acked-by: Vineet Gupta <vgupta@synopsys.com>  [arch/arc bits]

-Vineet
