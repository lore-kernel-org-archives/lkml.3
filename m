Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbaHHOkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:40:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:25995 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbaHHOku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:40:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,825,1400050800"; 
   d="scan'208";a="573716283"
Message-ID: <53E4E151.2070301@linux.intel.com>
Date: Fri, 08 Aug 2014 07:40:17 -0700
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jeremiah Mahler <jmmahler@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH linux-next] doc: fix /sys/kernel/debug/.../tlb_single_page
 location
References: <1407484195-1441-1-git-send-email-jmmahler@gmail.com>
In-Reply-To: <1407484195-1441-1-git-send-email-jmmahler@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 12:49 AM, Jeremiah Mahler wrote:
> Fix the documented sys location of tlb_single_page_flush_ceiling
> which is under /sys/kernel/debug/... not /sys/debug/kernel/...

Thanks for finding that!

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
