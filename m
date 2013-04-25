Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3DYGYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 02:24:11 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:54938 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab3DYGYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 02:24:09 -0400
Date: Thu, 25 Apr 2013 09:24:05 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: sparc64, mm BUG in 3.9-rc8
In-Reply-To: <20130424.195350.1927101733139114761.davem@davemloft.net>
Message-ID: <alpine.SOC.1.00.1304250923320.21668@math.ut.ee>
References: <alpine.SOC.1.00.1304230019030.12820@math.ut.ee> <20130423.161751.2116707386990845036.davem@davemloft.net> <20130424.143615.334401973542739420.davem@davemloft.net> <20130424.195350.1927101733139114761.davem@davemloft.net>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This fixes it, I'll push this to Linus immediately.
> 
> Thanks for your report!
> 
> --------------------
> sparc64: Fix missing put_cpu_var() in tlb_batch_add_one() when not batching.

Thank you, this patch fixes it on my 220R and 420R too.

-- 
Meelis Roos (mroos@linux.ee)
