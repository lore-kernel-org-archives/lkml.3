Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab3FRAMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 20:12:21 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:57261 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab3FRAMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 20:12:20 -0400
Date: Tue, 18 Jun 2013 02:12:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 1/2] hw_breakpoint: Simplify
 *register_wide_hw_breakpoint()
Message-ID: <20130618001214.GA15563@somewhere.redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
 <20130602194912.GA3277@redhat.com>
 <20130602195011.GB3277@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130602195011.GB3277@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 02, 2013 at 09:50:11PM +0200, Oleg Nesterov wrote:
> 1. register_wide_hw_breakpoint() can use unregister_ if failure,
>    no need to duplicate the code.
> 
> 2. "struct perf_event **pevent" adds the unnecesary lever of
>    indirection and complication, use per_cpu(*cpu_events, cpu).
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
