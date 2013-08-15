Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691Ab3HOTWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 15:22:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12458 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757086Ab3HOTWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 15:22:13 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=F0my4ousGMIA:10 a=7Vahp7kjsuqt3vje45cA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 15 Aug 2013 15:22:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.10.6-rt3
Message-ID: <20130815152210.5ed93696@gandalf.local.home>
In-Reply-To: <520D212F.7030400@localhost>
References: <20130812163413.GI23040@linutronix.de>
	<520D212F.7030400@localhost>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Aug 2013 11:42:55 -0700
Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:

> On 08/12/2013 09:34 AM, Sebastian Andrzej Siewior wrote:
> > Dear RT folks!
> >
> > I'm pleased to announce the v3.10.6-rt3 patch set.
> 
> I'm getting this when trying to build:
> 
> drivers/md/bcache/request.c: In function 'cached_dev_write_complete':
> drivers/md/bcache/request.c:1008:2: error: implicit declaration of 
> function 'up_read_non_owner' [-Werror=implicit-function-declaration]
>    up_read_non_owner(&dc->writeback_lock);
>    ^
> drivers/md/bcache/request.c: In function 'request_write':
> drivers/md/bcache/request.c:1034:2: error: implicit declaration of 
> function 'down_read_non_owner' [-Werror=implicit-function-declaration]
>    down_read_non_owner(&dc->writeback_lock);
>    ^
> cc1: some warnings being treated as errors
> 

Can you send us your config.

Thanks,

-- Steve
