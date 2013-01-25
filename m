Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab3AYKii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:38:38 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:49409 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab3AYKih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:38:37 -0500
Date: Fri, 25 Jan 2013 11:38:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, jolsa@redhat.com,
        namhyung.kim@lge.com
Subject: Re: [PATCH v7 00/18] perf: add memory access sampling support
Message-ID: <20130125103832.GB20826@gmail.com>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359040242-8269-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> This patch series had a new feature to the kernel perf_events 
> interface and corresponding user level tool, perf.

Ok, so I have created a topic tree for this, tip:perf/x86.

I have applied the kernel bits (with some minor renaming 
changes). Arnaldo, if you agree with the tooling bits you can 
merge that branch into your tree and apply the tooling bits from 
Stephane.

Thanks,

	Ingo
