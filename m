Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3J1C3p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 22:29:45 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:38866 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab3J1C3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 22:29:44 -0400
Date: Sun, 27 Oct 2013 22:37:46 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Will Deacon <will.deacon@arm.com>
Subject: perf: PERF_EVENT_IOC_PERIOD on ARM vs everywhere else
Message-ID: <alpine.DEB.2.10.1310272233120.12721@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

it was pointed out to me that in the 3.7 kernel (more specifically,
3581fe0ef37ce12ac7a4f74831168352ae848edc ) a change was made in the
ARM architecture to change how PERF_EVENT_IOC_PERIOD is handled.

Unlike other architectures, post-3.7 ARM updates the period right away 
rather than waiting until the next overflow.

I can't find any discussion as to why this change was made.

Should other architectures be updated to?  I just wanted to find out the 
rationale for this before I update the manpage to reflect the difference 
in behaviors between architectures.

Vince
