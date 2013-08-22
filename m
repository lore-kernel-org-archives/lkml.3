Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab3HVJBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 05:01:44 -0400
Received: from mail.renton.name ([90.155.165.44]:37089 "EHLO
	beaver.old-horrors.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab3HVJBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 05:01:40 -0400
X-Greylist: delayed 723 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Aug 2013 05:01:39 EDT
Date: Thu, 22 Aug 2013 12:47:42 +0400
From: Alexey Vlasov <renton@renton.name>
To: linux-kernel@vger.kernel.org
Subject: There is strange packets dropping on new kernels
Message-ID: <20130822084742.GD13676@beaver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I noticed that tcpdump shows many dropped packets on new kernels.
It looks like that:

# tcpdump -n -i eth0 -c 10
...
10 packets captured
10 packets received by filter
0 packets dropped by kernel
4294967268 packets dropped by interface
# uname -r
3.10.7

On old kernels the same command doesn't drop anything.
# tcpdump -n -i eth0 -c 10
10 packets captured
140 packets received by filter
0 packets dropped by kernel
# uname -r
3.8.11

What can I do to fix it? Or is it right?
Thanks.

-- 
BRGDS. Alexey Vlasov.
