Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab3F0O0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:26:18 -0400
Received: from ozlabs.org ([203.10.76.45]:43299 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab3F0O0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:26:17 -0400
Date: Fri, 28 Jun 2013 00:26:14 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com, sukadev@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH v3 1/2] perf tools: fix a typo of a Power7 event name
Message-ID: <20130627142614.GC13867@concordia>
References: <1372170933-4538-1-git-send-email-runzhen@linux.vnet.ibm.com>
 <1372170933-4538-2-git-send-email-runzhen@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372170933-4538-2-git-send-email-runzhen@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 10:35:32PM +0800, Runzhen Wang wrote:
> In the Power7 PMU guide:
> https://www.power.org/documentation/commonly-used-metrics-for-performance-analysis/
> PM_BRU_MPRED is referred to as PM_BR_MPRED.
> 
> It fixed the typo by changing the name of the event in kernel
> and documentation accordingly.

This patch fixes the typo by ...

> This patch changes the ABI, there are some reasons I think it's ok:
> 
> - It is relatively new interface, specific to the Power7 platform.
> 
> - No tools that we know of actually use this interface at this point
>  (none are listed near the interface).
> 
> - Users of this interface (eg oprofile users migrating to perf)
>   would be more used to the "PM_BR_MPRED" rather than "PM_BRU_MPRED".
> 
> - These are in the ABI/testing at this point rather than ABI/stable,
>   so hoping we have some wiggle room.
> 
> Signed-off-by: Runzhen Wang <runzhen@linux.vnet.ibm.com>

Acked-by: Michael Ellerman <michael@ellerman.id.au>

cheers
