Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab3GETMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 15:12:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:1164 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214Ab3GETMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 15:12:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1003,1363158000"; 
   d="scan'208";a="365384223"
Date: Fri, 5 Jul 2013 12:12:31 -0700
From: Andi Kleen <ak@linux.jf.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        jolsa@redhat.com, zheng.z.yan@intel.com, namhyung.kim@lge.com
Subject: Re: [PATCH] perf stat: fix per-socket output bug for uncore events
Message-ID: <20130705191231.GE5643@tassilo.jf.intel.com>
References: <20130705170645.GA32519@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130705170645.GA32519@quad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Reported-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Stephane Eranian <eranian@google.com>

Tested-by: Andi Kleen <ak@linux.intel.com>

Works for me. Thanks.

-Andi
