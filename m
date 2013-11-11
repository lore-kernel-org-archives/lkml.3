Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3KKP7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:59:37 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37432 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab3KKP7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:59:31 -0500
Date: Mon, 11 Nov 2013 16:59:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v6 3/4] perf,x86: add Intel RAPL PMU support
Message-ID: <20131111155905.GM19203@twins.programming.kicks-ass.net>
References: <1383939963-7750-1-git-send-email-eranian@google.com>
 <1383939963-7750-4-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383939963-7750-4-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 08:46:02PM +0100, Stephane Eranian wrote:


> +static DEFINE_SPINLOCK(rapl_hotplug_lock);

What is this thing protecting?

Like last time it appears to be used only from hotplug notifier
callbacks and those are already fully serialized.

