Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaLCGS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 01:18:58 -0500
Received: from ozlabs.org ([103.22.144.67]:52568 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbaLCGS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 01:18:57 -0500
Message-ID: <1417587532.16722.12.camel@concordia>
Subject: Re: [PATCH v5 1/6] perf: provide sysfs_show for struct
 perf_pmu_events_attr
From: Michael Ellerman <mpe@ellerman.id.au>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>, peterz@infradead.org,
        linuxppc-dev@lists.ozlabs.org, dev@codyps.com,
        linux-kernel@vger.kernel.org
Date: Wed, 03 Dec 2014 17:18:52 +1100
In-Reply-To: <1417572235-8197-2-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1417572235-8197-1-git-send-email-sukadev@linux.vnet.ibm.com>
	 <1417572235-8197-2-git-send-email-sukadev@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-02 at 18:03 -0800, Sukadev Bhattiprolu wrote:
> From: Cody P Schafer <cody@linux.vnet.ibm.com>
> 
> (struct perf_pmu_events_attr) is defined in include/linux/perf_event.h,
> but the only "show" for it is in x86 and contains x86 specific stuff.
> 
> Make a generic one for those of us who are just using the event_str.
> 
> CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> CC: Haren Myneni <hbabu@us.ibm.com>
> CC: Cody P Schafer <dev@codyps.com>
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  include/linux/perf_event.h | 3 +++
>  kernel/events/core.c       | 8 ++++++++
>  2 files changed, 11 insertions(+)

Acme/Peterz, are you happy for us to take this series through the powerpc tree?
Do you want to give us an ack for patches 1 & 2?

cheers



