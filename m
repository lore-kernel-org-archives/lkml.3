Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758425Ab3G3XgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 19:36:13 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48068 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757174Ab3G3XgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 19:36:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Cross <ccross@android.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Michael Leun <lkml20130126@newton.leun.net>,
        Pavel Machek <pavel@ucw.cz>, Linux PM list <linux-pm@vger.kernel.org>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH] power: set PF_SUSPEND_TASK flag on tasks that call freeze_processes
Date: Wed, 31 Jul 2013 01:46:20 +0200
Message-ID: <4007751.kC1oJrggef@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CA+55aFzGwoYq+BRBx23045AG=fWzVEtGcN-7xBTi9o=rkGhU3A@mail.gmail.com>
References: <1374712893-14487-1-git-send-email-ccross@android.com> <17002595.Gazy686Cvx@vostro.rjw.lan> <CA+55aFzGwoYq+BRBx23045AG=fWzVEtGcN-7xBTi9o=rkGhU3A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 25, 2013 04:51:20 PM Linus Torvalds wrote:
> On Thu, Jul 25, 2013 at 1:06 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > Can we spend an extra process flag on that?
> 
> I suspect we can. But if somebody hollers later, we'll need to do some
> compaction..

OK, if we need that flag for something more important, it shouldn't be too
difficult to recycle.

And I'm not seeing any complaints, so I'm going to fast-track this, as it
fixes a recent regression.

Rafael

