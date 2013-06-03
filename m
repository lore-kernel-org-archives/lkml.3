Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab3FCOJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 10:09:14 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:51255 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816Ab3FCOJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 10:09:11 -0400
Date: Mon, 3 Jun 2013 17:09:07 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: MTRR cleanup regression since 3.10-rc3
In-Reply-To: <alpine.SOC.1.00.1306031032360.6602@math.ut.ee>
Message-ID: <alpine.SOC.1.00.1306031703430.25565@math.ut.ee>
References: <alpine.SOC.1.00.1306031032360.6602@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Tried 3.10-rc4 on my testbed and 3 machines report problems with MTRR 
> cleanup. Two of them were different P3 PCs both with i815 chipset, and 
> third was dual P3 server with Gigabyte 6ETXDR mainboard (Broadcom 
> CNB20LE chipset).

Actually, even a newish Sandy Bridge PC with Intel DQ67OW mainboard and 
4G RAM shows this. So it seems to be more common than I thought.

-- 
Meelis Roos <mroos@linux.ee>
