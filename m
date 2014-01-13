Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaAMPnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:43:47 -0500
Received: from www.sr71.net ([198.145.64.142]:40436 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbaAMPnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:43:45 -0500
Message-ID: <52D40957.2020103@sr71.net>
Date: Mon, 13 Jan 2014 07:42:15 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>, Davidlohr Bueso <davidlohr@hp.com>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] re-shrink 'struct page' when SLUB is on.
References: <20140103180147.6566F7C1@viggo.jf.intel.com> <20140103141816.20ef2a24c8adffae040e53dc@linux-foundation.org> <20140106043237.GE696@lge.com> <52D05D90.3060809@sr71.net> <20140110153913.844e84755256afd271371493@linux-foundation.org> <52D0854F.5060102@sr71.net> <CAOJsxLE-oMpV2G-gxrhyv0Au1tPd87Ow57VD5CWFo41wF8F4Yw@mail.gmail.com> <alpine.DEB.2.10.1401111854580.6036@nuc> <20140113014408.GA25900@lge.com> <1389584218.11984.0.camel@buesod1.americas.hpqcorp.net> <20140113134609.GB31640@localhost>
In-Reply-To: <20140113134609.GB31640@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 05:46 AM, Fengguang Wu wrote:
>>> So, I think
>>> that it is better to get more benchmark results to this patchset for convincing
>>> ourselves. If possible, how about asking Fengguang to run whole set of
>>> his benchmarks before going forward?
>>
>> Cc'ing him.
> 
> My pleasure. Is there a git tree for the patches? Git trees
> are most convenient for running automated tests and bisects.

Here's a branch:

https://github.com/hansendc/linux/tree/slub-reshrink-for-Fengguang-20140113

My patches are not broken out in there, but that's all the code that
needs to get tested.
