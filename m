Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaFEL6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 07:58:36 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:43546 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaFEL6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 07:58:34 -0400
Date: Thu, 5 Jun 2014 13:58:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC 2/2] perf: add AUX area to ring buffer for raw data streams
Message-ID: <20140605115829.GA29720@gmail.com>
References: <1400166510-9234-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1400166510-9234-3-git-send-email-alexander.shishkin@linux.intel.com>
 <20140519085854.GW30445@twins.programming.kicks-ass.net>
 <87bnuuylha.fsf@ashishki-desk.ger.corp.intel.com>
 <20140520095102.GV2485@laptop.programming.kicks-ass.net>
 <8761kzz0v1.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761kzz0v1.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Shishkin <alexander.shishkin@linux.intel.com> wrote:

> @@ -300,6 +300,7 @@ struct pmu {
>   * struct pmu::capabilities flags
>   */
>  #define PERF_PMU_CAP_NO_INTERRUPT	1
> +#define PERF_PMU_CAP_AUX_BROKEN_SG	2

Btw., I'd name it PERF_PMU_AUX_PHYSICAL_SG or so, and add a comment 
before it that explains that such hardware interfaces are restrictive, 
or so.

Thanks,

	Ingo
