Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaCNINz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 04:13:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34916 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbaCNINw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 04:13:52 -0400
Date: Fri, 14 Mar 2014 09:13:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com,
        acme@redhat.com, namhyung@kernel.org, jolsa@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] perf, x86: Disallow setting undefined bits for PEBS
 events
Message-ID: <20140314081338.GL27965@twins.programming.kicks-ass.net>
References: <1394745733-27855-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394745733-27855-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 02:22:12PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> The SDM forbids setting various event qualifiers with PEBS
> events. The magic cycles:pp event uses it, but it has caused
> problems in the past. We continue allowing it for cycles:pp,
> but forbid it for all other events to follow the SDM.

Last time this came up I asked for what kind of problems it caused.

No answer then I think, and certainly no answer now.

