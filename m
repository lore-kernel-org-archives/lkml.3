Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916AbaJ2PLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:11:43 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:57093 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933775AbaJ2PLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:11:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: opw-kernel@googlegroups.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Heena Sirwani <heenasirwani@gmail.com>, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org
Subject: Re: [OPW kernel] Re: [PATCH v8 0/2] Added ktime_get_seconds() and ktime_get_real_seconds()
Date: Wed, 29 Oct 2014 16:11:04 +0100
Message-ID: <2064687.Au5VJFYEvM@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1410291518300.5308@nanos>
References: <cover.1414578445.git.heenasirwani@gmail.com> <alpine.DEB.2.11.1410291518300.5308@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Bc8lePSCSstDLEly4Tjzkl3fstaIGLbQ2b19MnRQOpv
 dBpJwoZuR0AJoUcUIrsjLugpYGKd/0oTTYYHFVpH2t4DviYpz1
 47TPSB9igbmSrSDVpRHaEuX0KcKTRt370+kfsLG1VSVAGnK2lV
 w6v0Auj/Q5GB/D8Xch9nwlznQ/kG1sltRhUHEktTK8nV8lmUxA
 f1qjLFK8LN6hMxOASL1bsYye3glnW89/QMxPZrnIsAS77xxITI
 71iuzkNbFrQ5iNBxzKRzw659pYLG+PeO2ViiAeIXIs1IN8dTiA
 bq1PryO6oZBqca+IIJZK07t6W8eMxKgUeS5psGVlhWus5CiVdO
 rZDXeIwJJLqLBWRw/IRE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 October 2014 15:21:16 Thomas Gleixner wrote:
> On Wed, 29 Oct 2014, Heena Sirwani wrote:
> 
> > The following patchset adds two functions as follows:
> >       -ktime_get_seconds() to return tv_sec portion of
> >       ktime_get_ts64().
> >       -ktime_get_real_seconds() to return tv_sec portion of
> >       ktime_get_real_ts64().
> > 
> > Changes in v8:
> >       -changed type of ktime_sec to unsigned long
> >       - Added a patch with ktime_get_real_seconds().
> 
> Heena, thanks for your patience and for following up to the reviews.
> 
> I merged the lot into tip timers/2038. Thats a new branch reserved for
> the 2038 work.
> 
> Arnd, feel free to pull that branch into your tree for the patches
> which depend on those interfaces.
> 

Thanks a lot!

I've rebased my y2038 tree on top of that now, and merged Heena's
"[PATCH v6] cpuset: Replace all instances of time_t with time64_t"
on top of that.

	Arnd
