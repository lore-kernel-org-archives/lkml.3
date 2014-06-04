Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbaFDW3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:29:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:41528 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbaFDW3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:29:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,975,1392192000"; 
   d="scan'208";a="542598853"
Date: Wed, 4 Jun 2014 15:28:57 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        jolsa@redhat.com, zheng.z.yan@intel.com,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH 0/9] perf/x86: implement HT counter corruption workaround
Message-ID: <20140604222857.GB16855@tassilo.jf.intel.com>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401917658-26065-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is no HW or FW workaround for this problem.

Actually there is for global measurements: 

measure with Any bit set and divide by two.

Please add a check that the any bit is set, and disable
the workaround for that case.

-Andi

