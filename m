Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbbALQhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:37:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:29760 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbbALQhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:37:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,744,1413270000"; 
   d="scan'208";a="649888853"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        acme@infradead.org
Subject: Re: [PATCH v8 12/14] x86: perf: intel_pt: Intel PT PMU driver
In-Reply-To: <20150109140947.GN3337@twins.programming.kicks-ass.net>
References: <1415972627-37514-1-git-send-email-alexander.shishkin@linux.intel.com> <1415972627-37514-13-git-send-email-alexander.shishkin@linux.intel.com> <20150109140947.GN3337@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 12 Jan 2015 18:37:36 +0200
Message-ID: <87sifg9cq7.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> Also, if its already enabled, should we not return ENODEV as well, no
> saying who or what programmed it, we should not be touching it.

Or EBUSY?

Regards,
--
Alex
