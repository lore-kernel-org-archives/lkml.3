Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbaGIOyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:54:17 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58148 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013AbaGIOxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:53:55 -0400
Date: Wed, 9 Jul 2014 11:53:43 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com,
        jolsa@redhat.com
Subject: Re: [PATCH v1 0/4] perf: add ability to sample interrupted machine
 state
Message-ID: <20140709145343.GA2384@redhat.com>
References: <1404857759-25105-1-git-send-email-eranian@google.com>
 <87mwcj2b0z.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwcj2b0z.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 09, 2014 at 05:26:20PM +0900, Namhyung Kim escreveu:
> On Wed,  9 Jul 2014 00:15:55 +0200, Stephane Eranian wrote:
> > This patch series is the fundation for a future series adding
> > function value profiling.
> 
> Probably a silly question: what is the function value profiling?

I think he wants to sample the values of parameters and local variables,
etc, right?

http://lists.cs.uiuc.edu/pipermail/llvmdev/2013-June/062950.html lists
some things you can do with that.

Stephane, is that what you mean by "value profiling"?

- Arnaldo
