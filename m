Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaCHAnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 19:43:32 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:8763 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751663AbaCHAna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 19:43:30 -0500
Date: Fri, 7 Mar 2014 19:43:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ktest: add 2nd parameter of run_command() to set
 the redirect target file
Message-ID: <20140307194328.038b5a12@gandalf.local.home>
In-Reply-To: <878uslft00.wl%satoru.takeuchi@gmail.com>
References: <87vbvwokq8.wl%satoru.takeuchi@gmail.com>
	<878uslft00.wl%satoru.takeuchi@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 08 Mar 2014 09:12:31 +0900
Satoru Takeuchi <satoru.takeuchi@gmail.com> wrote:

> Hi Steven,
> 
> At Sun, 02 Mar 2014 21:20:31 +0900,
> Satoru Takeuchi wrote:
> > 
> > From: Satoru Takeuchi <satoru.takeuchi@gmail.com>
> > 
> > If we'd like to set the redirect target file of run_command(),
> > we should define $redirect before calling this function and should undef it
> > after calling this function. Since it's user-unfriendly, add 2nd parameter of
> > run_command() for this purpose.
> > 
> > Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> 
> Could you tell whether this patch will be applied? Although you told me that you
> won't apply the following patch, I didn't hear about this patch.

Ah, I was thinking this one was needed for the next patch, so I didn't
apply it.

> 
> > [PATCH 2/2] ktest: run make mrproper not only for OUTPUT_DIR but also for BUILD_DIR to avoid build failure
> 
> I make this question since I'll send next patch set this weekend and want to
> know whether I can make patch on the top of this patch.

You can add this one again. I haven't really reviewed it, but if other
patches depend on it, include it as well. Include it anyway if you want
me to review it.

Thanks,

-- Steve


