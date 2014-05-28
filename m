Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaE1UGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:06:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:58938 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbaE1UGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:06:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,929,1392192000"; 
   d="scan'208";a="547978385"
Date: Wed, 28 May 2014 13:06:00 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Dave Hansen <dave.hansen@intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [RFC] perf/x86: PMU IRQ handler issues
Message-ID: <20140528200600.GR29957@tassilo.jf.intel.com>
References: <CABPqkBTsiwicZNuU5BW6FZfB4aC=T=w9vFoxLqBTV3-PS4BnoA@mail.gmail.com>
 <20140528195528.GQ29957@tassilo.jf.intel.com>
 <CABPqkBRW8akWWrRgFwatHbui6+0JqXi=8T2N_JHZ_x4zLuq9EQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRW8akWWrRgFwatHbui6+0JqXi=8T2N_JHZ_x4zLuq9EQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 09:56:35PM +0200, Stephane Eranian wrote:
> On Wed, May 28, 2014 at 9:55 PM, Andi Kleen <ak@linux.intel.com> wrote:
> >
> >> Another explanation is that because we ACK the NMI early, we leave the
> >> door open to other interrupts, incl. NIC, and we are interrupting the execution
> >
> > PMI executes with interrupts off.
> >
> And that's coming from where?

The interrupt gate.

-Andi

