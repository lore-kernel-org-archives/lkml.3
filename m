Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab3CXPQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 11:16:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab3CXPQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 11:16:36 -0400
Date: Sun, 24 Mar 2013 16:15:55 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCHv2 0/6] perf, signal x86: Fix breakpoint events overflow
 handling
Message-ID: <20130324151555.GA1076@krava.brq.redhat.com>
References: <1362940871-24486-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362940871-24486-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 07:41:05PM +0100, Jiri Olsa wrote:
> hi,
> sendign v2 for initial RFC patchset:
> https://lkml.org/lkml/2013/3/1/324
> 
> v2 changes:
>   - added patch to merge EFLAGS bit clearing into single statement

hi,
any feedback on this?

thanks,
jirka
