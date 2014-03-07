Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaCGNTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:19:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbaCGNTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:19:49 -0500
Date: Fri, 7 Mar 2014 14:19:28 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@redhat.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, eranian@google.com, namhyung@kernel.org
Subject: Re: [PATCH 2/8] perf, tools: Support handling complete branch stacks
 as histograms v4
Message-ID: <20140307131928.GA13974@krava.brq.redhat.com>
References: <1393561352-23448-1-git-send-email-andi@firstfloor.org>
 <1393561352-23448-3-git-send-email-andi@firstfloor.org>
 <20140305102948.GB1835@krava.brq.redhat.com>
 <20140305153149.GQ12219@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305153149.GQ12219@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 07:31:49AM -0800, Andi Kleen wrote:
> > segfaults here..
> > 
> > [jolsa@krava perf]$ ./perf record -g sleep 1
> > [ perf record: Woken up 1 times to write data ]
> > [ perf record: Captured and wrote 0.013 MB perf.data (~567 samples) ]
> > [jolsa@krava perf]$ ./perf report
> > perf: Segmentation fault
> > [jolsa@krava perf]$ 
> 
> Thanks. Fixed with this patch:
> 
> commit 124014960a8fb09043914fb79ea86e0444408ab0
> Author: Andi Kleen <ak@linux.intel.com>
> Date:   Wed Mar 5 07:28:56 2014 -0800
> 
>     perf, tools, report: Fix perf report without -b
>     
>     Fix report crash when -b is not used. Reported by Jiri Olsa.
>     
>     Signed-off-by: Andi Kleen <ak@linux.intel.com>

you need to merge it with the original one,
so we dont have broken build.. git bisect wise

same for the gtk stuff

jirka
