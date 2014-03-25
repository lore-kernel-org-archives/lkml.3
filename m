Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbaCYQQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 12:16:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:9992 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbaCYQQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 12:16:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,728,1389772800"; 
   d="scan'208";a="499220769"
Date: Tue, 25 Mar 2014 09:16:44 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [V5 0/4] perf: New conditional branch filter
Message-ID: <20140325161644.GC15074@tassilo.jf.intel.com>
References: <1394183185-6219-1-git-send-email-khandual@linux.vnet.ibm.com>
 <53319829.9040403@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53319829.9040403@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hey Arnaldo,
> 
> Do you have any comments or suggestions on this ? Have not received any
> response on these proposed patch series yet. Thank you.

I read it earlier and it looks good to me.

-Andi
