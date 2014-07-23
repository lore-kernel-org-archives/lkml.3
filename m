Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbaGWQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:25:28 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:37062 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793AbaGWQZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:25:27 -0400
Message-ID: <53CFE1F4.60705@adfin.com>
Date: Wed, 23 Jul 2014 12:25:24 -0400
From: Milosz Tanski <milosz@adfin.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>
CC: Thomas Gleixner <tglx@timesys.com>, Eric Dumazet <dada1@cosmosbay.com>,
        Darren Hart <dvhltc@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: futex: wake explicit / wait on multiple memory locations
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using futexes to control scheduling for a userspace application with multiple queues. There's a global work queue and a specific pre-thread queue. And I would like to have a choice between waking up any thread or a specific thread.

Is there are mechanism in the futex API by which I can control which thread to wake up. Or alternatively a mechanism by which have a thread wait on multiple futex memory locations?

Thanks in advance,
- Milosz
