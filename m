Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab3FXIpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 04:45:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45643 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3FXIpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 04:45:24 -0400
Date: Mon, 24 Jun 2013 10:45:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH 2/8] perf,x86: drop event->flags and use
 hw.constraint->flags
Message-ID: <20130624084510.GK28407@twins.programming.kicks-ass.net>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
 <1371824448-7306-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371824448-7306-3-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 04:20:42PM +0200, Stephane Eranian wrote:
> Now that we use the contraints directly from the event, we
> do not need the event->flags field so drop it.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Same for this one I suppose; its not really related to the series at
hand.
