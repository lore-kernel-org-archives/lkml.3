Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaCKAnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 20:43:31 -0400
Received: from one.firstfloor.org ([193.170.194.197]:47253 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaCKAna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 20:43:30 -0400
Date: Tue, 11 Mar 2014 01:43:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        mingo@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com,
        namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/8] perf, tools: Support handling complete branch
 stacks as histograms v4
Message-ID: <20140311004329.GQ22728@two.firstfloor.org>
References: <1393561352-23448-1-git-send-email-andi@firstfloor.org>
 <1393561352-23448-3-git-send-email-andi@firstfloor.org>
 <20140307131949.GC13974@krava.brq.redhat.com>
 <20140307195100.GA6519@infradead.org>
 <20140307195408.GB6519@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307195408.GB6519@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Humm, then it gets overly long and we have
> PERF_RECORD_MISC_CPUMODE_UNKNOWN, so I'll try making it so that if
> cpumode is passed as PERF_RECORD_MISC_CPUMODE_UNKNOWN,
> thread__find_addr_location() will try to figure it out.

I implemented Jiri's suggestion for now, just renaming the functions.

-Andi
