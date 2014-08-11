Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaHKRYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:24:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:49518 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbaHKRYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:24:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,843,1400050800"; 
   d="scan'208";a="575088785"
Message-ID: <53E8FC32.6070905@linux.intel.com>
Date: Mon, 11 Aug 2014 10:24:02 -0700
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jeremiah Mahler <jmmahler@gmail.com>, David Rientjes <rientjes@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 linux-next] arch/x86/mm: sparse 'tlb_single_page_flush_ceiling'
 warning
References: <alpine.DEB.2.02.1408081503270.15603@chino.kir.corp.google.com> <1407569913-4035-1-git-send-email-jmmahler@gmail.com>
In-Reply-To: <1407569913-4035-1-git-send-email-jmmahler@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2014 12:38 AM, Jeremiah Mahler wrote:
> A sparse warning is generated about 'tlb_single_page_flush_ceiling'
> not being declared.
> 
>   arch/x86/mm/tlb.c:177:15: warning: symbol
>   'tlb_single_page_flush_ceiling' was not declared. Should it be static?
> 
> Since it isn't used anywhere outside this file, fix the warning by
> making it static.
> 
> Also, optimize the use of this variable by adding the __read_mostly
> directive.

Looks fine to me.  It's definitely __read_mostly.

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
