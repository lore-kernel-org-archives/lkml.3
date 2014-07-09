Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbaGIPoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:44:24 -0400
Received: from mga14.intel.com ([192.55.52.115]:64349 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756414AbaGIPoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:44:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,631,1400050800"; 
   d="scan'208";a="559466908"
Date: Wed, 9 Jul 2014 08:44:21 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        jolsa@redhat.com, acme@redhat.com, namhyung@kernel.org
Subject: Re: [PATCH 3/4] perf tools: add core support for sampling intr
 machine state regs
Message-ID: <20140709154421.GX19781@tassilo.jf.intel.com>
References: <1404857759-25105-1-git-send-email-eranian@google.com>
 <1404857759-25105-4-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404857759-25105-4-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +int perf_event__parse_sample(const union perf_event *event, u64 type,
> +			     int sample_size, bool sample_id_all,
> +			     u64 sample_regs_user, u64 sample_stack_user,
> +			     u64 sample_regs_intr,
> +			     struct perf_sample *data, bool swapped);

Why is this only a prototype?

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
