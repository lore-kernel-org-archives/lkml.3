Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3IZRS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:18:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab3IZRS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:18:26 -0400
Date: Thu, 26 Sep 2013 13:18:21 -0400 (EDT)
Message-Id: <20130926.131821.1371932451518980586.davem@redhat.com>
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

> As it happens, 198144 is the value from Aug 10 2012 and it happens to be 
> 00030600 hex. Here is the culprit, we are not rebuilding 
> include/linux/version.h.

That explains everything, thanks for tracking it down.
