Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab3GVPRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:17:00 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:57102 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab3GVPQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:16:59 -0400
Date: Mon, 22 Jul 2013 17:16:53 +0200
From: Kiko Piris <kernel@pirispons.net>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, srivatsa.bhat@linux.vnet.ibm.com
Subject: 3.10.1 cpufreq suspend/resume regression still present in 3.10.2
Message-ID: <20130722151653.GA7213@sacarino.pirispons.net>
Mail-Followup-To: Kiko Piris <kernel@pirispons.net>,
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
	srivatsa.bhat@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt
X-No-CC: Please respect my Mail-Followup-To header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

linux-3.10.1 introduced a regression in cpufreq breaking suspend/resume
cycle for some people [1].

There were also some other threads about it in lkml.

I see 3.10.2-stable was released some days ago. I couldn’t see anything
about fixing this regression reported in the changelog.

And to be 110% certain, I compiled it and tried suspending/resuming;
it’s still broken.

Is this going to be fixed in 3.10 stable branch?

Thank you very much in advance.


[1] first commit that bisect informed as introducing the regression:

| commit c02527487f0c8feb578c0394ad481a97f26d3bd2
| Author: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
| Date:   Mon Jul 1 00:40:55 2013 +0200
|
|     cpufreq: Fix cpufreq regression after suspend/resume
|
|     commit f51e1eb63d9c28cec188337ee656a13be6980cfd upstream.

https://groups.google.com/forum/#!topic/linux.kernel/LUi1pFCxbSI

-- 
Kiko
