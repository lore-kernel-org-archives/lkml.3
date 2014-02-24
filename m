Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaBXOWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:22:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38743 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaBXOWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:22:43 -0500
Date: Mon, 24 Feb 2014 15:22:32 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH Resend] trace: Replace hardcoding of 19 with MAX_NICE.
Message-ID: <20140224142232.GU27965@twins.programming.kicks-ass.net>
References: <eeb2a85d74c71e0d50c88789f99ad857a6b4b7b4.1392103744.git.yangds.fnst@cn.fujitsu.com>
 <1393251121-25534-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393251121-25534-1-git-send-email-yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 10:12:01PM +0800, Dongsheng Yang wrote:
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

"Use MAX_NICE instead of the value 19 for ring_buffer_benchmark."

> cc: Steven Rostedt <rostedt@goodmis.org>
> cc: Frederic Weisbecker <fweisbec@gmail.com>
> cc: Ingo Molnar <mingo@redhat.com>
> cc: Peter Zijlstra <peterz@infradead.org>
> ---

Thanks.
