Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292AbaKPVuA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 16:50:00 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:43267 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751019AbaKPVt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 16:49:59 -0500
Date: Sun, 16 Nov 2014 16:49:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH v2 2/2] kernel-trace: Less calls for iput() in
 create_trace_uprobe() after error detection
Message-ID: <20141116164955.4f6f0c84@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.10.1411162034190.2364@hadrien>
References: <5307CAA2.8060406@users.sourceforge.net>
	<530A72AA.3000601@users.sourceforge.net>
	<alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	<530B5FB6.6010207@users.sourceforge.net>
	<alpine.DEB.2.10.1402241710370.2074@hadrien>
	<530C5E18.1020800@users.sourceforge.net>
	<alpine.DEB.2.10.1402251014170.2080@hadrien>
	<530CD2C4.4050903@users.sourceforge.net>
	<alpine.DEB.2.10.1402251840450.7035@hadrien>
	<530CF8FF.8080600@users.sourceforge.net>
	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	<530DD06F.4090703@users.sourceforge.net>
	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<5468ABBD.6000903@users.sourceforge.net>
	<alpine.DEB.2.10.1411161656340.2364@hadrien>
	<5468F756.8070807@users.sourceforge.net>
	<5468F96E.4090903@users.sourceforge.net>
	<20141116143120.44421df2@gandalf.local.home>
	<alpine.DEB.2.10.1411162034190.2364@hadrien>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2014 20:34:59 +0100 (CET)
Julia Lawall <julia.lawall@lip6.fr> wrote:

> I wuold have thought that one could have just returned, like in the cases
> above...  But maybe the printed message is useful.

Yes, it lets us know that the format string failed to parse.

-- Steve

