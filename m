Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab3F0PBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:01:35 -0400
Received: from dkim1.fusionio.com ([66.114.96.53]:41059 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3F0PBd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:01:33 -0400
X-ASG-Debug-ID: 1372345292-03d6a577cd151160001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Dave Jones <davej@redhat.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130627145824.GA21540@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
References: <20130627145824.GA21540@redhat.com>
Message-ID: <20130627150130.14981.39849@localhost.localdomain>
User-Agent: alot/0.3.4
Subject: Re: btrfs triggered lockdep WARN.
Date: Thu, 27 Jun 2013 11:01:30 -0400
X-ASG-Orig-Subj: Re: btrfs triggered lockdep WARN.
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas2.int.fusionio.com[10.101.1.41]
X-Barracuda-Start-Time: 1372345292
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.135124
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Jones (2013-06-27 10:58:24)
> Another bug caused by this script. https://github.com/kernelslacker/io-tests/blob/master/setup.sh

I'm still struggling to reproduce that one here.  I've tried every
variation I can think of but I'll try again.

I really hope you don't already have CONFIG_DEBUG_PAGE_ALLOC turned on,
maybe it will catch this?

-chris
