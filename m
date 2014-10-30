Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161445AbaJ3Wqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 18:46:52 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:32042 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161326AbaJ3Wqv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 18:46:51 -0400
Date: Thu, 30 Oct 2014 18:46:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Pavel Vasilyev <pavel@pavlinux.ru>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.2.63-rt92
Message-ID: <20141030184643.615d2e19@gandalf.local.home>
In-Reply-To: <5452BAD5.7080007@pavlinux.ru>
References: <20141030180729.256bb5b9@gandalf.local.home>
	<5452BAD5.7080007@pavlinux.ru>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014 01:25:25 +0300
Pavel Vasilyev <pavel@pavlinux.ru> wrote:

> 31.10.2014 01:07, Steven Rostedt пишет:
> >
> > Dear RT Folks,
> >
> > I'm pleased to announce the 3.2.63-rt92 stable release.
> 
> Cool!!!
> 
> For latest, stable,... 3.14/3.16/3.18 will be?
> 
> 

If Thomas and Sebastian are done with 3.14, I'll be happy to add it to
the stable releases.

As for 3.16/3.18? Please read:

  https://lwn.net/Articles/617140/

-- Steve
