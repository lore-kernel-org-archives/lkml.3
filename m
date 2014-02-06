Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaBFXPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 18:15:48 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:38137 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaBFXPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 18:15:46 -0500
Message-ID: <52F4179C.70400@gmail.com>
Date: Fri, 07 Feb 2014 00:15:40 +0100
From: Bastien Traverse <bastien.traverse@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Francis Moreau <francis.moro@gmail.com>
CC: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: 3.12: ethernet controller missing after resuming from suspend
 to RAM
References: <52F2CC7B.80406@gmail.com> <52F33BE7.2040607@gmail.com> <2240387.gpLEHJv4c1@vostro.rjw.lan>
In-Reply-To: <2240387.gpLEHJv4c1@vostro.rjw.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 06/02/2014 08:38, Francis Moreau a écrit :
> I'm still leaving with this issue since my initial posting
> unfortunately :(

Damn, I was hoping you'd have found a workaround for this by now. It is
quite severe though!

> I'm wondering why PM support on this machine is so crapish

My quick research turned up a few results ([1],[2],[3]) for similar bug
with other setups, however there are rather old and not met with a fix.
But yeah, this machine has some undeniable defects, a faulty BIOS made
me RMA it just after its purchase.

> (it initialy oopsed when resuming due to a bug in rtsx driver).

I was also hit by the rtsx driver bug
(https://bugs.archlinux.org/task/37720) and was delighted with its fast
resolution. I was hoping that its fix would also address the
disappearing Ethernet bug.

Le 06/02/2014 13:40, Rafael J. Wysocki a écrit :
> Is this a new problem in 3.12?

There is a ticket in kernel bugzilla [4] that involves r8169 and
suspend/resume or rather hibernate/resume. This bug involves kernels
prior to 3.12, but I can't tell if it is really related.

3.12.x is the first and only kernel I tried on this machine (well I do
have Debian 7 in dual boot but I haven't used it since I installed it).

Would it help if I'd try another distribution with older kernel? If so,
would doing it from LiveUSB be a valid way?


[1] https://bbs.archlinux.org/viewtopic.php?id=98399
[2] https://bugs.launchpad.net/ubuntu/+source/network-manager/+bug/45696
[3] http://forums.linuxmint.com/viewtopic.php?f=150&t=36708&p=211140
[4] https://bugzilla.kernel.org/show_bug.cgi?id=45911
