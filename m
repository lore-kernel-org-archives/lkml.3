Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab3DWHed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 03:34:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45354 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402Ab3DWHeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 03:34:31 -0400
Date: Tue, 23 Apr 2013 03:34:30 -0400 (EDT)
Message-Id: <20130423.033430.807606126530680062.davem@davemloft.net>
To: mroos@linux.ee
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: sparc64, mm BUG in 3.9-rc8
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1304231020550.28316@math.ut.ee>
References: <alpine.SOC.1.00.1304230947380.27055@math.ut.ee>
	<20130423.030721.841236427967286989.davem@davemloft.net>
	<alpine.SOC.1.00.1304231020550.28316@math.ut.ee>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 23 Apr 2013 00:34:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Tue, 23 Apr 2013 10:21:31 +0300 (EEST)

>> From: Meelis Roos <mroos@linux.ee>
>> Date: Tue, 23 Apr 2013 09:47:54 +0300 (EEST)
>> 
>> >> Thanks, could you post a prtconf dump from this machine?  I'll
>> >> add it to the prtconf GIT repo as well.
>> > 
>> > Attached.
>> 
>> Thanks a lot.
> 
> Actually, it was Fire 480R, not Enterprise, so the e in e420r filename 
> is wrong...

I've renamed the file to just plain '480r', thanks.
