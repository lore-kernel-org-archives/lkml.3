Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab3HVKvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 06:51:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50846 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab3HVKvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 06:51:19 -0400
Date: Thu, 22 Aug 2013 12:51:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com,
        dsahern@gmail.com
Subject: Re: [PATCH v2 2/2] perf tools: add attr->mmap2 support
Message-ID: <20130822105109.GI31370@twins.programming.kicks-ass.net>
References: <1377079825-19057-1-git-send-email-eranian@google.com>
 <1377079825-19057-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377079825-19057-3-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 12:10:25PM +0200, Stephane Eranian wrote:
> This patch adds support for the new PERF_RECORD_MMAP2
> record type exposed by the kernel. This is an extended
> PERF_RECORD_MMAP record. It adds for each file-backed
> mapping the device major, minor number and the inode
> number and generation. This triplet uniquely identifies
> the source of a file-backed mapping. It can be used to
> detect identical virtual mappings between processes, for
> instance.
> 
> The patch will prefer MMAP2 over MMAP.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Acme, ACK?
