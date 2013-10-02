Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab3JBK7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:59:17 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:59241 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab3JBK7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:59:15 -0400
Message-ID: <524BFC74.6060401@linaro.org>
Date: Wed, 02 Oct 2013 13:59:00 +0300
From: Ciprian Barbu <ciprian.barbu@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: tglx@linutronix.de, aarcange@redhat.com
Subject: CONFIG_TRANSPARENT_HUGEPAGE with PREEMPT_RT_FULL
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

(resending due to HTML formatting)

I am looking into using CONFIG_TRANSPARENT_HUGEPAGE with PREEMPT_RT_FULL 
but currently the latest rt patch has it disabled.

What I managed to find on the mailing list so far is that Yong Zhang 
reported a crash on rt_spin_lock for which you suggested to disable 
CONFIG_TRANSPARENT_HUGEPAGE until further notice. That was on Jul 24, 
2011 so I was wondering if you have any more news on that. Is there any 
hope to get transparent hugepages working with preempt_rt? Any estimate 
on how difficult a fix for that will be?

Also, we ran some basic ltp mm and ltp hugetlb on an rt image with 
transparent hugepages, on an ARM arndale, and didn't get any problems. 
Do you think it's possible that the problem got fixed somewhere along 
the way?

Thanks and regards,
Ciprian
