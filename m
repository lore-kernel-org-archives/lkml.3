Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab3JBPOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:14:24 -0400
Received: from relay3.sgi.com ([192.48.152.1]:46718 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753138Ab3JBPOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:14:20 -0400
Message-Id: <20131002151417.707425834@asylum.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 02 Oct 2013 10:14:17 -0500
From: Mike Travis <travis@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Add back capability of calling KGDB/KDB via UV NMI call.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following two patches add the capability of calling KGDB/KDB after
receiving the NMI signal from the UV system 'power nmi' command.  This
is mainly required because the system console on UV cannot send the
break signal so when the system I/O is not working, the power nmi
command from the CMC is the only method to interrupt the system.

-- 
