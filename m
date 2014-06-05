Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaFEVvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 17:51:22 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57303 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbaFEVvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 17:51:17 -0400
X-Nat-Received: from [202.181.97.72]:64255 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1402005073.6518
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: Change in security maintainer for a few weeks
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20140605183050.GA5054@kroah.com>
In-Reply-To: <20140605183050.GA5054@kroah.com>
Message-Id: <201406060651.DBH82897.FQVOLFMOFJOHSt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 6 Jun 2014 06:51:12 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 04062014 #8144375, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Hi all,
> 
> James has had to step back from doing kernel work for a few weeks, so
> I've offered to step up and handle the security patches to get shuttled
> to Linus for merging for a while.
> 
> I'll take his git tree on kernel.org and push those to Linus for
> 3.16-rc1, as those look like they have had proper testing in linux-next.
> 
> But there only seems to be 14 patches in there.  Are there pending
> patches that people have been sending and need to get in besides those?

I have two patches.

http://marc.info/?l=linux-security-module&m=140122694916418&w=4
I got an ACK from each subsystem maintainer and expected it to go to
3.15-final, but seems that it can't even go to 3.16-final for unknown
reason because James is not responding. Maybe James wants this patch
reviewed by more people, but it seems to me that linux-security-module ML
itself is not working.

http://marc.info/?l=linux-security-module&m=140180521023726&w=4
It got reviewed by Paul and Serge, but seems that it can't go to
3.16-final for unknown reason.
