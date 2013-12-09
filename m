Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596Ab3LINk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:40:29 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:49009 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933351Ab3LINk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:40:28 -0500
Message-ID: <52A5C846.30308@linaro.org>
Date: Mon, 09 Dec 2013 21:40:22 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        preeti@linux.vnet.ibm.com, LAK <linux-arm-kernel@lists.infradead.org>,
        "len.brown@intel.com" <len.brown@intel.com>
Subject: questions of cpuidle
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry for a idiot of cpuidle.

I just find few cpu set TIMER_STOP on cpuidle, like omap4 and big.Little
driver. Does that mean other ARM cpu or x86 cpu can get the timer
interrupt in cpuidle?

If the timer stopped during cpuidle, does that means at least one cpu
cann't get into deep c-state since system need a cpu to wake up other
deep c-state cpu? Or sth I missed?

If the cpu stopped the interrupt during deep c-state and without
monitor/mwait support, which kind of ipi can wake the cpu? I mean like a
x86 cpu, APIC stopped in c3 mode, but actually ipi send via apic bus. So
I don't know which ipi work?

-- 
Thanks
    Alex
