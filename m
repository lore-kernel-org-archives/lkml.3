Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaEVHIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 03:08:44 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:47832 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaEVHIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 03:08:43 -0400
Message-ID: <537DA126.4060102@linux.vnet.ibm.com>
Date: Thu, 22 May 2014 12:33:02 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mpe@ellerman.id.au, benh@kernel.crashing.org
Subject: Re: [V6 01/11] perf: Add PERF_SAMPLE_BRANCH_COND
References: <1400666396-1682-1-git-send-email-khandual@linux.vnet.ibm.com> <1400666396-1682-2-git-send-email-khandual@linux.vnet.ibm.com> <20140521113025.GC2485@laptop.programming.kicks-ass.net> <537D73A6.2050403@linux.vnet.ibm.com> <20140522070105.GL30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140522070105.GL30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052207-9264-0000-0000-00000624AC37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 12:31 PM, Peter Zijlstra wrote:
> On Thu, May 22, 2014 at 09:18:54AM +0530, Anshuman Khandual wrote:
> 
>> Hope this new change log below makes more sense.
> 
> Yep reads a whole lot better. Thanks.
> 

Will resend the first four patches with this new commit messages without
changing the overall version of the patchset. Hope thats okay.

