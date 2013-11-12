Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab3KLSLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:11:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:17205 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081Ab3KLSLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:11:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,686,1378882800"; 
   d="scan'208";a="432219007"
Date: Tue, 12 Nov 2013 10:10:33 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v7 0/4] perf/x86: add Intel RAPL PMU support
Message-ID: <20131112181033.GD3499@tassilo.jf.intel.com>
References: <1384275531-10892-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384275531-10892-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In v7, we rebased to 3.12+ and dropped the hotplug cpu lock because it
> was not needed. Hotplug CPU is still serialized.

Looks all good to me. Thanks for working on this.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi
