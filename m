Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbaGBPse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:48:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:63239 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823AbaGBPsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:48:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,588,1400050800"; 
   d="scan'208";a="564229221"
Date: Wed, 2 Jul 2014 08:48:28 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf, x86: Revamp PEBS event selection
Message-ID: <20140702154828.GO19781@tassilo.jf.intel.com>
References: <1403910612-8754-1-git-send-email-andi@firstfloor.org>
 <1403910612-8754-2-git-send-email-andi@firstfloor.org>
 <CABPqkBT1XC=mG-ZhjAcMOksdCgP-p3TSSAefi7XBOajMugBYZQ@mail.gmail.com>
 <20140702153300.GM19781@tassilo.jf.intel.com>
 <CABPqkBQvSGA2k4eSHg54k3i8cTotviuvY71RuSc=Rh0iuxaPxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQvSGA2k4eSHg54k3i8cTotviuvY71RuSc=Rh0iuxaPxg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 05:44:05PM +0200, Stephane Eranian wrote:
> On Wed, Jul 2, 2014 at 5:33 PM, Andi Kleen <ak@linux.intel.com> wrote:
> >> No, still needs to be INTEL_ALL_EVENT_CONSTRAINT(0x0, 0x1)
> >> otherwise the get_event_constraint() test I mentioned previously will
> >> fail, event with your ALL_FILTER mask.
> >
> > What events should fail? I verified all PEBS events and they work as expected.
> >
> Random events should not fail, they should go with precise and not generate
> any samples. That's the whole point of the exercise.
> 
> perf record -a -e r6099:p sleep 1

Like I said I ran all PEBS events and they generated samples.

-Andi
