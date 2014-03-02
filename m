Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaCBOYH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 09:24:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:38694 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752309AbaCBOYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 09:24:05 -0500
Date: Sun, 2 Mar 2014 09:24:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ktest: run make mrproper not only for OUTPUT_DIR
 but also for BUILD_DIR to avoid build failure
Message-ID: <20140302092402.6c42bc68@gandalf.local.home>
In-Reply-To: <87sir0ofax.wl%satoru.takeuchi@gmail.com>
References: <87vbvwokq8.wl%satoru.takeuchi@gmail.com>
	<87txbgokl3.wl%satoru.takeuchi@gmail.com>
	<20140302082916.58199d86@gandalf.local.home>
	<87sir0ofax.wl%satoru.takeuchi@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Mar 2014 23:17:42 +0900
Satoru Takeuchi <satoru.takeuchi@gmail.com> wrote:

> At Sun, 2 Mar 2014 08:29:16 -0500,
> Steven Rostedt wrote:
> > 
> > On Sun, 02 Mar 2014 21:23:36 +0900
> > Satoru Takeuchi <satoru.takeuchi@gmail.com> wrote:
> > 
> > > From: Satoru Takeuchi <satoru.takeuchi@gmail.com>
> > > 
> > > Build failure hapens with the following log if BUILD_DIR is dirty.
> > 
> > If you want to do make mrproper in the BUILD_DIR, add the command to
> > PRE_BUILD or something. I have TAGS in my BUILD_DIRs and this will
> > remove them for me. I can't accept this change.
> > 
> > I've noticed that there's a bug in the Linux make system that causes
> > the O=.. builds to fail because somehow the source directory got dirty.
> > We need to figure out what that bug is.
> 
> I see. So what I should fix is kbuild system.
> 

That would be great :-)

-- Steve
