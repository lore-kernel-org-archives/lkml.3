Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaJAVmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:42:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:21539 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbaJAVmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:42:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,634,1406617200"; 
   d="scan'208";a="608385302"
From: Andi Kleen <andi@firstfloor.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v2 00/11] perf: Intel Cache QoS Monitoring support
References: <1412174192-7010-1-git-send-email-matt@console-pimps.org>
Date: Wed, 01 Oct 2014 14:42:05 -0700
In-Reply-To: <1412174192-7010-1-git-send-email-matt@console-pimps.org> (Matt
	Fleming's message of "Wed, 1 Oct 2014 15:36:21 +0100")
Message-ID: <8738b7eac2.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Fleming <matt@console-pimps.org> writes:
>
> Changes in v2:
>
>  - Added Jiri Olsa's Acked-by to PATCH 02/11.
>
>  - Use x86_match_cpu() in intel_cqm_init() and make sure we grab the
>    hotplug lock to prevent races as pointed out by Andi Kleen in
>    PATCH 08/11.
>
>  - Delete a stale comment in commit message of PATCH 10/11.

No support for a modular driver?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
