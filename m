Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab3FATtq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 15:49:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab3FATti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 15:49:38 -0400
Date: Sat, 1 Jun 2013 21:45:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 0/3] hw_breakpoint: cleanups
Message-ID: <20130601194526.GA27149@redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Cleanups, on top of

	[PATCH 0/2]: WARN_ONCE in arch/x86/kernel/hw_breakpoint.c

series.

Oleg.

 kernel/events/hw_breakpoint.c |   91 ++++++++++++++++-------------------------
 1 files changed, 35 insertions(+), 56 deletions(-)

