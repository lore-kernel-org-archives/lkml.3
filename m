Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab3J1SOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 14:14:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:25065 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756788Ab3J1SOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 14:14:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="426058654"
Message-ID: <526EA947.7060608@intel.com>
Date: Mon, 28 Oct 2013 11:13:27 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Richard Davies <richard@arachsys.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
CC: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: Unnecessary mass OOM kills on Linux 3.11 virtualization host
References: <20131024224326.GA19654@alpha.arachsys.com> <20131025103946.GA30649@alpha.arachsys.com> <20131028082825.GA30504@alpha.arachsys.com>
In-Reply-To: <20131028082825.GA30504@alpha.arachsys.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 01:28 AM, Richard Davies wrote:
> I further attach some other types of memory manager errors found in the
> kernel logs around the same time. There are several occurrences of each, but
> I have only copied one here for brevity:
> 
> 19:18:27 kernel: BUG: Bad page map in process qemu-system-x86  pte:00000608 pmd:1d57fd067

FWIW, I took a quick look through your OOM report and didn't see any
obvious causes for it.  But, INMHO, you should probably ignore the OOM
issue until you've fixed these "Bad page map" problems.   Those are a
sign of a much deeper problem.
