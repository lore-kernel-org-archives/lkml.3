Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab3LEEr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 23:47:57 -0500
Received: from ozlabs.org ([203.10.76.45]:45072 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab3LEEr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 23:47:56 -0500
Message-ID: <1386218874.6009.7.camel@concordia>
Subject: Re: [PATCH V4 00/10] perf: New conditional branch filter
From: Michael Ellerman <mpe@ellerman.id.au>
To: acme@ghostprotocols.net
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, mikey@neuling.org,
        ak@linux.intel.com, eranian@google.com, sukadev@linux.vnet.ibm.com,
        mingo@kernel.org, Anshuman Khandual <khandual@linux.vnet.ibm.com>
Date: Thu, 05 Dec 2013 15:47:54 +1100
In-Reply-To: <1386153162-11225-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1386153162-11225-1-git-send-email-khandual@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-04 at 16:02 +0530, Anshuman Khandual wrote:
> 		This patchset is the re-spin of the original branch stack sampling
> patchset which introduced new PERF_SAMPLE_BRANCH_COND branch filter. This patchset
> also enables SW based branch filtering support for book3s powerpc platforms which
> have PMU HW backed branch stack sampling support. 
> 
> Summary of code changes in this patchset:
> 
> (1) Introduces a new PERF_SAMPLE_BRANCH_COND branch filter
> (2) Add the "cond" branch filter options in the "perf record" tool
> (3) Enable PERF_SAMPLE_BRANCH_COND in X86 platforms
> (4) Enable PERF_SAMPLE_BRANCH_COND in POWER8 platform 
> (5) Update the documentation regarding "perf record" tool


Hi Arnaldo,

Can you please take just patches 1-5 into the perf tree? And do you mind
putting them in a topic branch so Benh can merge that.

The remaining patches are powerpc specific and still need some more review.

cheers


