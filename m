Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab3FASZI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 14:25:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab3FASZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 14:25:00 -0400
Date: Sat, 1 Jun 2013 20:20:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 0/2]: WARN_ONCE in arch/x86/kernel/hw_breakpoint.c
Message-ID: <20130601182057.GA4861@redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20, Vince Weaver wrote:
>
> on 3.10-rc1 with the trinity fuzzer patched to exercise the
> perf_event_open() syscall I am triggering this WARN_ONCE:
>
> [   75.864822] ------------[ cut here ]------------
> [   75.864830] WARNING: at arch/x86/kernel/hw_breakpoint.c:121 arch_install_hw_breakpoint+0x5b/0xcb()

Ingo,

I am not sure about -stable, but probably this is 3.10 material.

Oleg.

