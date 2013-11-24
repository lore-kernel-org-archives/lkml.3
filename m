Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab3KXSLL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 13:11:11 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:46228 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab3KXSLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 13:11:07 -0500
Message-ID: <52924132.2080209@c-s.fr>
Date: Sun, 24 Nov 2013 19:10:58 +0100
From: christophe leroy <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: perf events: how to implement TLB misses as SW event ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 131124-0, 24/11/2013), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today in the perfevents subsystem it looks like DTLB/ITLB misses are 
implemented as HW counter only.
On some processors, like PowerPC 8xx, there is no counter for that. 
However DTLB/ITLB misses are handled as exceptions via software, so we 
have an opportunity to implement a SW counter for that.
What's the easiest/best way to implement it ?

Christophe
