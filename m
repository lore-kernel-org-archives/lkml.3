Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaIVOoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:44:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818AbaIVOoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:44:06 -0400
Date: Mon, 22 Sep 2014 16:43:19 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        peterz@infradead.org, eranian@google.com,
        Paul Mackerras <paulus@samba.org>, dev@codyps.com,
        Michael Ellerman <michaele@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>, hbabu@us.ibm.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 00/10] Add support for parameterized events from sysfs
Message-ID: <20140922144318.GG18187@krava.brq.redhat.com>
References: <1410979923-7722-1-git-send-email-sukadev@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410979923-7722-1-git-send-email-sukadev@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 11:51:53AM -0700, Sukadev Bhattiprolu wrote:

SNIP

> 
> 	This means that when provided as an event, a value for
> 	phys_processor_idx must also be supplied. For example:
> 
> 	  perf stat -e 'hv_gpci/dtbp_ptitc,phys_processor_idx=0x2/' ...
> 
> Changelog[v3]
> 	- [Jiri Olsa] Changed the event parameters are specified. If
> 	  event file specifes 'param=val' make the usage 'param=123'
> 	  rather than 'val=123'. (patch 1,2/10)
> 	- Shortened event names using "PHYS" and "VCPU" (patch 4/10)
> 	- Print help message if invalid parameter is specified or required
> 	  parameter is missing.
> 	- Moved 3 patches that are unrelated to parametrized events into
> 	  a separate patchset.
> 	- Reordered patches so code changes come first.

hi,
Could you please rebase to latest acme/perf/core?
There were some changes in util/pmu.c conflicting with yours..

thanks,
jirka
