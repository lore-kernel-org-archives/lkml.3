Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3JJCL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 22:11:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:19194 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752100Ab3JJCLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 22:11:49 -0400
Date: Wed, 9 Oct 2013 22:11:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [RFC/PATCH] ftrace: add set_graph_notrace filter
Message-ID: <20131009221144.3be54f27@gandalf.local.home>
In-Reply-To: <87vc15ki4l.fsf@sejong.aot.lge.com>
References: <1378184708-31385-1-git-send-email-namhyung@kernel.org>
	<87txh2okn9.fsf@sejong.aot.lge.com>
	<1380599926.16752.7.camel@pippen.local.home>
	<87vc15ki4l.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Oct 2013 10:51:54 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Steve,
> 
> On Mon, 30 Sep 2013 23:58:46 -0400, Steven Rostedt wrote:
> > On Mon, 2013-09-30 at 16:04 +0900, Namhyung Kim wrote:
> >> Ping!
> >
> > Ah I missed this patch. And I'm currently traveling.
> >
> > I'll start testing it when I get back on Friday, but feel free to ping
> > me again next Monday.
> 
> Would you take a look at it this time? :)

Yep! I just finished a bunch of stuff, and now have time to look into
patches. I'm working backward (although I should be working forward).
I'll definitely get to this tomorrow.

-- Steve
