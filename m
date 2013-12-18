Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3LRKHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:07:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25048 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab3LRKHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:07:48 -0500
Message-ID: <52B173DD.1020304@oracle.com>
Date: Wed, 18 Dec 2013 15:37:25 +0530
From: Allen Pais <allen.pais@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 2/3] [RESEND]sparc64: convert spinloc_t to raw_spinlock_t
 in  mmu_context_t
References: <1387345326-20185-1-git-send-email-allen.pais@oracle.com> <52B16182.9090209@linutronix.de>
In-Reply-To: <52B16182.9090209@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Sorry for not noticing this earlier but this has nothing to do with the
> remaining part of the patch.
> To be able to set this flag, you need to mark timer & perf interrupts.
> If you already use IRQF_TIMER for the timer and perf interrupts are
> already coming as NMU then you are done. But please split this out as a
> separate patch.

I'll split this as a separate patch. 

- Allen

