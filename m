Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaANVmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:42:45 -0500
Received: from www.sr71.net ([198.145.64.142]:54092 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbaANVmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:42:42 -0500
Message-ID: <52D5AEF7.6020707@sr71.net>
Date: Tue, 14 Jan 2014 13:41:11 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, penberg@kernel.org
Subject: Re: [RFC][PATCH 2/9] mm: slub: abstract out double cmpxchg option
References: <20140114180042.C1C33F78@viggo.jf.intel.com> <20140114180046.C897727E@viggo.jf.intel.com> <alpine.DEB.2.10.1401141346310.19618@nuc>
In-Reply-To: <alpine.DEB.2.10.1401141346310.19618@nuc>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 11:49 AM, Christoph Lameter wrote:
> On Tue, 14 Jan 2014, Dave Hansen wrote:
>> I found this useful to have in my testing.  I would like to have
>> it available for a bit, at least until other folks have had a
>> chance to do some testing with it.
> 
> I dont really see the point of this patch since we already have
> CONFIG_HAVE_ALIGNED_STRUCT_PAGE to play with.

With the current code, if you wanted to turn off the double-cmpxchg abd
get a 56-byte 'struct page' how would you do it?  Can you do it with a
.config, or do you need to hack the code?
