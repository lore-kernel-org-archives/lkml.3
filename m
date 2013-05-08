Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab3EHAYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 20:24:24 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:44365 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab3EHAYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 20:24:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130506102534.GC22348@linutronix.de>
References: <20130506102534.GC22348@linutronix.de>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 7 May 2013 20:23:51 -0400
X-Google-Sender-Auth: fB41EgGZfMSCV2QkJuLdWPLrAOI
Message-ID: <CAP=VYLpx1=2_pSar65y1g5Y=0f8gLVA0noOoJcfUg76cmVq0Jg@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.8.11-rt8
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 6:25 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> Dear RT Folks,
>
> I'm pleased to announce the 3.8.11-rt8 release.
>
> changes since v3.8.11-rt7:
> - suspend / resume related fix has been fixed
> - don't wakeup blocked workers (Steven Rostedt)

As per the 3.6.x RT releases[1], there was value in tracking the
per release changes for those people who were using the plain old
linear patch queues, and integrating that into their work.

So this repo continues that for the v3.8.x RT patch queue.  This is
done in the same way that the stable releases have been done,
which is also done in the same way as I did the 3.6.x-RT git
tracking repo.  Meaning that it tracks the changes within a
repository of patches.

You can see the per-release changes in RT-3.8.x by browsing the
history in this patch repository:

http://git.kernel.org/cgit/linux/kernel/git/paulg/3.8-rt-patches.git/

The idea is that you can get the 3.8.x updates by cloning this
repo, and then issuing a "git pull" on it as updates are added by
Sebastian (and hence mirrored to this kernel.org repo by me)

Paul.
--

[1]  http://git.kernel.org/cgit/linux/kernel/git/paulg/3.6-rt-patches.git/
