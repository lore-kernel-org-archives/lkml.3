Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab3IZSJC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:09:02 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:60628 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829Ab3IZSJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:09:00 -0400
Date: Thu, 26 Sep 2013 21:08:56 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@redhat.com>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: include/linux/version.h not updated
In-Reply-To: <20130926.132628.780580796759839483.davem@redhat.com>
Message-ID: <alpine.SOC.1.00.1309262107190.27277@math.ut.ee>
References: <20130926.002304.2121420558807412031.davem@davemloft.net> <alpine.SOC.1.00.1309261347030.11084@math.ut.ee> <alpine.SOC.1.00.1309261601050.11084@math.ut.ee> <20130926.132628.780580796759839483.davem@redhat.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -rw-r--r-- 1 mroos mroos 97 Sep 20 21:56 include/generated/uapi/linux/version.h
> > -rw-r--r-- 1 mroos mroos 97 Aug 10  2012 ./include/linux/version.h
> 
> It's not the it doesn't get updated.
> 
> It's that the file in your GIT tree is unsync'd.
> 
> You need to "rm include/linux/version.h" and I bet that beforehand a
> "git stat" will show "include/linux/version.h" as a spurious file.
> 
> Because of your situation, the second file is being included first,
> overriding the right file, the first one.

Yes, you are absolutely correct. head_64.o was rebuild with correcxt 
verion information.

A lot of machines will have this file removed :)

-- 
Meelis Roos (mroos@linux.ee)
