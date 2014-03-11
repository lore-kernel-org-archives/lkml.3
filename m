Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbaCKT4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:56:15 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:14211 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755236AbaCKT4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:56:12 -0400
Date: Tue, 11 Mar 2014 15:56:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ktest: remove the misleading $buildonly and
 introduce $laststep.
Message-ID: <20140311155610.432605f1@gandalf.local.home>
In-Reply-To: <87ob1dvtr6.wl%satoru.takeuchi@gmail.com>
References: <87ha7730nw.wl%satoru.takeuchi@gmail.com>
	<87fvmr30kb.wl%satoru.takeuchi@gmail.com>
	<87eh2b30ce.wl%satoru.takeuchi@gmail.com>
	<20140310121300.485d2202@gandalf.local.home>
	<87ppltvu37.wl%satoru.takeuchi@gmail.com>
	<87ob1dvtr6.wl%satoru.takeuchi@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014 20:50:53 +0900
Satoru Takeuchi <satoru.takeuchi@gmail.com> wrote:
 
> > > I just need to test them for a bit before I push them to my kernel.org
> > > repo. I don't actually have a test suite for ktest. My testing is that
> > > I use ktest on a daily basis, and I just use the latest devel ktest for
> > > my daily activities. If something breaks, I usually notice, unless it's
> > > affects something I haven't done recently (like a bisect).
> > 
> > I'll make and send my testsuite later. I considers that
> > tools/testing/ktest/example is suitable to place it.
> 
> Sorry, actually tools/testing/ktest/tests.
> .../examples/ is for examples for configs file as written in examples/README.

If the code looks clean, I have no problems with adding it.

Perhaps call the directory "selftests" that way it wont be confusing to
what is there. Especially if you add a README that states that the
tests in that directory are for the purpose of testing ktest.pl itself.

-- Steve
