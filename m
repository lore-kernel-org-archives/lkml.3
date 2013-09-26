Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab3IZR0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:26:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab3IZR0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:26:31 -0400
Date: Thu, 26 Sep 2013 13:26:28 -0400 (EDT)
Message-Id: <20130926.132628.780580796759839483.davem@redhat.com>
To: mroos@linux.ee
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: include/linux/version.h not updated
From: David Miller <davem@redhat.com>
In-Reply-To: <alpine.SOC.1.00.1309261601050.11084@math.ut.ee>
References: <20130926.002304.2121420558807412031.davem@davemloft.net>
	<alpine.SOC.1.00.1309261347030.11084@math.ut.ee>
	<alpine.SOC.1.00.1309261601050.11084@math.ut.ee>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Thu, 26 Sep 2013 16:12:55 +0300 (EEST)

> -rw-r--r-- 1 mroos mroos 97 Sep 20 21:56 include/generated/uapi/linux/version.h
> -rw-r--r-- 1 mroos mroos 97 Aug 10  2012 ./include/linux/version.h

It's not the it doesn't get updated.

It's that the file in your GIT tree is unsync'd.

You need to "rm include/linux/version.h" and I bet that beforehand a
"git stat" will show "include/linux/version.h" as a spurious file.

Because of your situation, the second file is being included first,
overriding the right file, the first one.
