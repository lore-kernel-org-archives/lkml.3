Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab3ARABU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 19:01:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:33648 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab3ARABT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 19:01:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,488,1355126400"; 
   d="scan'208";a="275244774"
Date: Thu, 17 Jan 2013 16:01:18 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH 0/2] perf stat: add interval counter printing
Message-ID: <20130118000118.GC4051@tassilo.jf.intel.com>
References: <1358436287-22883-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358436287-22883-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 04:24:45PM +0100, Stephane Eranian wrote:
> This small patchset extends perf stat with the -T option.

I already use that option for my haswell patchkit for transactional
monitoring.  Sorry, please use something else.

I agree it's a useful feature, although it can be simulated today.

-Andi
