Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab3GCDKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 23:10:33 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:41854 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab3GCDKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 23:10:32 -0400
Date: Tue, 2 Jul 2013 23:15:59 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: [bisected] perf: yet another fuzzer triggered crash
In-Reply-To: <alpine.DEB.2.10.1307021628510.8353@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1307022314450.11385@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1306121911500.12627@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306140058520.8617@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306281531070.10799@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306281705340.10799@vincent-weaver-1.um.maine.edu>
 <20130701090713.GO6626@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1307011112090.8216@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1307021628510.8353@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK, I have bisected this problem to the following change:

commit 8dc85d547285668e509f86c177bcd4ea055bcaaf
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Thu Sep 2 16:50:03 2010 +0200

    perf: Multiple task contexts
    
    Provide the infrastructure for multiple task contexts.

