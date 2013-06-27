Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3F0Hzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:55:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:23687 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab3F0Hza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:55:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,950,1363158000"; 
   d="scan'208";a="336253774"
Message-ID: <51CBF155.9050605@intel.com>
Date: Thu, 27 Jun 2013 11:01:25 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/15] perf tools: validate perf event header size
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com> <1372079772-20803-10-git-send-email-adrian.hunter@intel.com> <87wqph1w8x.fsf@sejong.aot.lge.com>
In-Reply-To: <87wqph1w8x.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/06/13 04:44, Namhyung Kim wrote:
> Hi Adrian,
> 
> On Mon, 24 Jun 2013 16:16:06 +0300, Adrian Hunter wrote:
>> 'size' includes the header so must be at least
>> 'sizeof(struct perf_event_header)'.  Error out
>> immediately if that is not the case.  Also
> 
> Just out of curiosity.
> 
> Do you have an experience it really matters?  AFAICS such an invalid
> sample should be detected during sample processing.

The patch was written a long time ago so I don't remember sorry.

