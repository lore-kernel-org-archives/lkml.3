Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbaDVVcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:32:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757716AbaDVVcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:32:08 -0400
Message-ID: <5356DFC8.1060601@redhat.com>
Date: Tue, 22 Apr 2014 17:31:52 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, x86@kernel.org
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mgorman@suse.de, ak@linux.intel.com, alex.shi@linaro.org,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH 5/6] x86: mm: new tunable for single vs full TLB flush
References: <20140421182418.81CF7519@viggo.jf.intel.com> <20140421182426.D6DD1E8F@viggo.jf.intel.com>
In-Reply-To: <20140421182426.D6DD1E8F@viggo.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 02:24 PM, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Most of the logic here is in the documentation file.  Please take
> a look at it.
> 
> I know we've come full-circle here back to a tunable, but this
> new one is *WAY* simpler.  I challenge anyone to describe in one
> sentence how the old one worked.  Here's the way the new one
> works:
> 
> 	If we are flushing more pages than the ceiling, we use
> 	the full flush, otherwise we use per-page flushes.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
