Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbaAJXnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 18:43:37 -0500
Received: from www.sr71.net ([198.145.64.142]:54568 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbaAJXnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 18:43:35 -0500
Message-ID: <52D0854F.5060102@sr71.net>
Date: Fri, 10 Jan 2014 15:42:07 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, penberg@kernel.org,
        cl@linux-foundation.org
Subject: Re: [PATCH 0/9] re-shrink 'struct page' when SLUB is on.
References: <20140103180147.6566F7C1@viggo.jf.intel.com>	<20140103141816.20ef2a24c8adffae040e53dc@linux-foundation.org>	<20140106043237.GE696@lge.com>	<52D05D90.3060809@sr71.net> <20140110153913.844e84755256afd271371493@linux-foundation.org>
In-Reply-To: <20140110153913.844e84755256afd271371493@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 03:39 PM, Andrew Morton wrote:
>> I tested 4 cases, all of these on the "cache-cold kfree()" case.  The
>> first 3 are with vanilla upstream kernel source.  The 4th is patched
>> with my new slub code (all single-threaded):
>>
>> 	http://www.sr71.net/~dave/intel/slub/slub-perf-20140109.png
> 
> So we're converging on the most complex option.  argh.

Yeah, looks that way.

> So all this testing was performed in a VM?  If so, how much is that
> likely to have impacted the results?

Nope, none of it was in a VM.  All the results here are from bare-metal.


