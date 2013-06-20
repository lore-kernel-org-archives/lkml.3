Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935465Ab3FTBV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 21:21:27 -0400
Received: from ozlabs.org ([203.10.76.45]:52407 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934734Ab3FTBV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 21:21:26 -0400
Message-ID: <1371691282.21846.1.camel@concordia>
Subject: Re: [PATCH 1/2] perf tools: fix a typo of a Power7 event name
From: Michael Ellerman <michael@ellerman.id.au>
To: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com, sukadev@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, icycoder@gmail.com
Date: Thu, 20 Jun 2013 11:21:22 +1000
In-Reply-To: <1371633326-7696-1-git-send-email-runzhen@linux.vnet.ibm.com>
References: <1371633326-7696-1-git-send-email-runzhen@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-19 at 17:15 +0800, Runzhen Wang wrote:
> In the Power7 PMU guide:
> https://www.power.org/documentation/commonly-used-metrics-for-performance-analysis/
> PM_BRU_MPRED is referred to as PM_BR_MPRED.
> 
> This patch fix the typo by changing the name of the event in kernel and
> documentation accordingly.
> 
> Signed-off-by: Runzhen Wang <runzhen@linux.vnet.ibm.com>
> ---
>  .../testing/sysfs-bus-event_source-devices-events  |    2 +-
>  arch/powerpc/perf/power7-pmu.c                     |   12 ++++++------
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
> index 8b25ffb..3c1cc24 100644
> --- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
> +++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
> @@ -29,7 +29,7 @@ Description:	Generic performance monitoring events
>  
>  What: 		/sys/devices/cpu/events/PM_1PLUS_PPC_CMPL
>  		/sys/devices/cpu/events/PM_BRU_FIN
> -		/sys/devices/cpu/events/PM_BRU_MPRED
> +		/sys/devices/cpu/events/PM_BR_MPRED

So you're changing the ABI.

I think that's probably OK, but you at least need to mention _why_ you
think it's OK.

cheers

