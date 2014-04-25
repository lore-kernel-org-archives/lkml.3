Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaDYPHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:07:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:37771 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbaDYPHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:07:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,927,1389772800"; 
   d="scan'208";a="528356160"
Date: Fri, 25 Apr 2014 08:07:34 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org,
        linux-kernel@vger.kernel.org, namhyung@kernel.org
Subject: Re: [PATCH 01/10] perf, tools: Add jsmn `jasmine' JSON parser
Message-ID: <20140425150734.GM8874@tassilo.jf.intel.com>
References: <1397674172-30959-1-git-send-email-andi@firstfloor.org>
 <20140425131735.GF4116@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425131735.GF4116@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 03:17:35PM +0200, Jiri Olsa wrote:
> hi,
> I guess this is v3 for:
>   perf: Add support for full Intel event lists v2
> 
> right? I did not get the 0/10.. is it just rebase?
> 
> also 3/10 seems not finished:
>   [PATCH 03/10] fixup! perf, tools: Add support for text descriptions of events and alias add

I'll repost.

-Andi
