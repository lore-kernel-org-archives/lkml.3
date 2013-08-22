Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab3HVPCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 11:02:46 -0400
Received: from mail.renton.name ([90.155.165.44]:37719 "EHLO
	beaver.old-horrors.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab3HVPCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 11:02:45 -0400
Date: Thu, 22 Aug 2013 19:00:46 +0400
From: Alexey Vlasov <renton@renton.name>
To: linux-kernel@vger.kernel.org
Subject: Kernel migration eat CPUs
Message-ID: <20130822150046.GF13676@beaver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Beginning from 3.7 including 3.10 kernel, I noticed that from time to
time all CPUs turn out to be busy 100% and at the moment websites of my
clients work slowly or don’t work at all.

top screen:
https://www.dropbox.com/s/psuk2cwn6exinyd/3.9.cpu_migration.jpg

All CPUs are busy with kernel threads migration for about 3-5 minutes.
Exactly how often it periodically happens I don’t know, but it happens
once in 1-3 hours.

Approximately 30 my servers work on kernel 2.6.35 and there’s no such
problem there. We use kernels 3.7 – 3.9 on 5 servers and I see such
effect everywhere. If you downgrade on 2.6.35, then migration doesn’t
eat CPUs.

These servers are used for usual LAMP shared hosting.

Can I get migration as if on the kernel 2.6.35 or can this feature be
disabled?

-- 
BRGDS. Alexey Vlasov.
jabber: renton@1gb.ru
icq: 5128664
