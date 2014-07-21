Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbaGULFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:05:38 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:32956 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbaGULFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:05:34 -0400
Date: Mon, 21 Jul 2014 12:05:29 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [for-next][PATCH 20/32] sh: ftrace: Remove check of obsolete
 variable function_trace_stop
Message-ID: <20140721110529.GA32428@console-pimps.org>
References: <20140719131524.009152325@goodmis.org>
 <20140719131612.883904957@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140719131612.883904957@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul, at 09:15:44AM, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Nothing sets function_trace_stop to disable function tracing anymore.
> Remove the check for it in the arch code.
> 
> [ Please test this on your arch ]
> 
> Cc: Matt Fleming <matt@console-pimps.org>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/sh/Kconfig      |  1 -
>  arch/sh/lib/mcount.S | 24 ++----------------------
>  2 files changed, 2 insertions(+), 23 deletions(-)

I no longer have hardware to test this on, but it looks pretty straight
forward.

-- 
Matt Fleming, Intel Open Source Technology Center
