Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708Ab3ILGff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:35:35 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:60813 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3ILGfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:35:33 -0400
Date: Thu, 12 Sep 2013 08:35:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2 2/2] perf tools: add attr->mmap2 support
Message-ID: <20130912063529.GA11583@gmail.com>
References: <20130909192810.GA3825@infradead.org>
 <20130909194844.GB28428@ghostprotocols.net>
 <20130910130002.GD28428@ghostprotocols.net>
 <CABPqkBRgj71D8FkWtR-4K8g5ErWMt8YsV7FcmxQ3Uouj640Z0A@mail.gmail.com>
 <20130910131728.GE28428@ghostprotocols.net>
 <20130910195847.GA1866@ghostprotocols.net>
 <20130910201637.GB1866@ghostprotocols.net>
 <CABPqkBQvo9r5ArPKFBOyMap2LK+8mR5anMiCtvjL-WUmxJ3qgg@mail.gmail.com>
 <20130911145341.GF1866@ghostprotocols.net>
 <20130911152841.GA1860@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911152841.GA1860@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> I haven't performed all these tests when running on an older kernel, 
> just checked that PERF_RECORD_MMAP was present, PERF_RECORD_MMAP2, as 
> expected, were not, probably they will be present only for the 
> synthesized events, right? The ones coming from the kernel were all 
> PERF_RECORD_MMAP, as expected.

Older kernel functionality looked fine here.

Thanks,

	Ingo
