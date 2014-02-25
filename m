Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaBYDfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:35:37 -0500
Received: from ozlabs.org ([203.10.76.45]:59732 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbaBYDd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:33:29 -0500
In-Reply-To: <1392415338-16288-6-git-send-email-cody@linux.vnet.ibm.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 05/11] powerpc: add hv_gpci interface header
Message-Id: <20140225033328.1D5652C030B@ozlabs.org>
Date: Tue, 25 Feb 2014 14:33:27 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-14-02 at 22:02:09 UTC, Cody P Schafer wrote:
> "H_GetPerformanceCounterInfo" (refered to as hv_gpci or just gpci from
> here on) is an interface to retrieve specific performance counters and
> other data from the hypervisor. All outputs have a fixed format (and
> are represented as structs in this patch).

I still see unused stuff in here, can you strip it back to just what we need.
Same goes for the next patch.

cheers
