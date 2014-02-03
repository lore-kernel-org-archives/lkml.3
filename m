Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaBCQRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:17:39 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:45147 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaBCQRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:17:38 -0500
Message-ID: <52EFC11A.8010709@linaro.org>
Date: Tue, 04 Feb 2014 00:17:30 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: a LLC sched domain bug for panda board?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just run the 3.14-rc1 kernel on panda board. The only domain for it is
'CPU' domain, but this domain has no SD_SHARE_PKG_RESOURCES setting, it
has no sd_llc.

Guess the right domain for this board should be MC. So is it a bug?

..
/proc/sys/kernel/sched_domain/cpu0/domain0/name:CPU
..
/proc/sys/kernel/sched_domain/cpu1/domain0/name:CPU

-- 
Thanks
    Alex
