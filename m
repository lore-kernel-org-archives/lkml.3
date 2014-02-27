Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaB0DHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:07:47 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:3061 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753115AbaB0DHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:07:46 -0500
Date: Wed, 26 Feb 2014 22:07:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: pavel@pavlinux.ru
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.12-rt19
Message-ID: <20140226220743.28f61b33@gandalf.local.home>
In-Reply-To: <530A7C58.2060009@pavlinux.ru>
References: <20140223184727.GA12442@linutronix.de>
	<530A486A.2000802@pavlinux.ru>
	<530A4C00.5070205@pavlinux.ru>
	<alpine.DEB.2.02.1402232211300.21251@ionos.tec.linutronix.de>
	<530A7C58.2060009@pavlinux.ru>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014 02:55:20 +0400
Pavel Vasilyev <pavel@pavlinux.ru> wrote:

> No, because in positional number systems, an increase in the senior level,
> junior reset, but not stays the same. Mainline kernel and patches is senior level.

If you notice, there's no '.' between the mainline version and the rt
version. It's a dash "-rtX". What that number represents is the version
of the patch series for that release. We don't start a new version at
each stable release, but we do start a new one at each major release.

Thus, -rt19 is the 19th version of this rt patch series. When we rebase
on top of another major release, a lot of rewrites need to be done, and
we start a new version series.

Resetting the -rt number at each minor release would not be useful to
us and thus not necessary.

-- Steve
