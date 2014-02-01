Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266AbaBAF6v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 00:58:51 -0500
Received: from ozlabs.org ([203.10.76.45]:59165 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbaBAF6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 00:58:08 -0500
In-Reply-To: <1389916434-2288-6-git-send-email-cody@linux.vnet.ibm.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/8] powerpc: add 24x7 interface header
Message-Id: <20140201055807.8E65F2C00C7@ozlabs.org>
Date: Sat,  1 Feb 2014 16:58:07 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-16-01 at 23:53:51 UTC, Cody P Schafer wrote:
> 24x7 (also called hv_24x7 or H_24X7) is an interface to obtain
> performance counters from the hypervisor. These counters do not have a
> fixed format/possition and are instead documented in a "24x7 Catalog",
> which is provided by the hypervisor (that interface is also documented
> in this header).
> 
> This method of obtaining performance counters from the hypervisor is
> intended to paritialy replace the gpci interface.

Same comments as for the previous patch.

cheers
