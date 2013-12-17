Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3LQVM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 16:12:57 -0500
Received: from mx2.compro.net ([12.186.155.30]:56567 "HELO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751706Ab3LQVM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 16:12:56 -0500
X-Greylist: delayed 666 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Dec 2013 16:12:56 EST
X-BYPSHEADER: 8453371
X-SMScore: -1050
Message-ID: <52B0BBBD.3000704@compro.net>
Date: Tue, 17 Dec 2013 16:01:49 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: question about cpu_active_mask
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hope it is OK to ask a newbie question here. I'm trying to better 
understand the boot process. I can't seem to find where in the kernel 
sources the cpu_active_mask (defined in include/linux/cpumask.h) gets 
populated. I can see that it does get populated as it brings cpus online 
but it is not obvious to me where. I'm using a 32 bit 3.4.x flavor kernel.

Sorry for the noise and thanks for any pointers

Regards
Mark
