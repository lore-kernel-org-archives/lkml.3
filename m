Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbaEaVuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 17:50:09 -0400
Received: from mail.tomasu.net ([192.241.222.217]:32943 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbaEaVuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 17:50:08 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 May 2014 17:50:07 EDT
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Reply-To: thomas@fjellstrom.ca
Subject: Question on intel_pstate driver
Date: Sat, 31 May 2014 15:44:02 -0600
Message-ID: <1425705.adneRaQSNa@balsa>
User-Agent: KMail/4.12.4 (Linux/3.14-1-amd64; KDE/4.13.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've noticed a strange issue on my lenovo W530 laptop for a few months now. 
Even with just a few percent cpu use, it spins the cpu up to it's full boost 
on one or more cores, and tends to keep it there for an extended period. Ever 
since my laptop has been significantly warmer, and louder than it was a while 
back.

Cpu is a: i7-3720QM
Current kernel is: 3.14.4 (debian)

I've also tried vanilla kernels: 3.13, 3.14-rc8

Disabling the intel_pstep driver seems to disable boost states completely, 
which is odd, as I could swear it worked before without it.

Is there something I can do to keep boost states while reducing the heat and 
noise? It seems to be way over compensating for minimal amounts of cpu use.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
