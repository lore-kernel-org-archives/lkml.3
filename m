Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619AbaAKJ0U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 04:26:20 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:48882 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaAKJ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 04:26:17 -0500
MIME-Version: 1.0
In-Reply-To: <52D0854F.5060102@sr71.net>
References: <20140103180147.6566F7C1@viggo.jf.intel.com>
	<20140103141816.20ef2a24c8adffae040e53dc@linux-foundation.org>
	<20140106043237.GE696@lge.com>
	<52D05D90.3060809@sr71.net>
	<20140110153913.844e84755256afd271371493@linux-foundation.org>
	<52D0854F.5060102@sr71.net>
Date: Sat, 11 Jan 2014 11:26:16 +0200
X-Google-Sender-Auth: MpomBpeu8aMEDAbAuHDCsyFHLZ8
Message-ID: <CAOJsxLE-oMpV2G-gxrhyv0Au1tPd87Ow57VD5CWFo41wF8F4Yw@mail.gmail.com>
Subject: Re: [PATCH 0/9] re-shrink 'struct page' when SLUB is on.
From: Pekka Enberg <penberg@kernel.org>
To: Dave Hansen <dave@sr71.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 1:42 AM, Dave Hansen <dave@sr71.net> wrote:
> On 01/10/2014 03:39 PM, Andrew Morton wrote:
>>> I tested 4 cases, all of these on the "cache-cold kfree()" case.  The
>>> first 3 are with vanilla upstream kernel source.  The 4th is patched
>>> with my new slub code (all single-threaded):
>>>
>>>      http://www.sr71.net/~dave/intel/slub/slub-perf-20140109.png
>>
>> So we're converging on the most complex option.  argh.
>
> Yeah, looks that way.

Seems like a reasonable compromise between memory usage and allocation speed.

Christoph?

                        Pekka
