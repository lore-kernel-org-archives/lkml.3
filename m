Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbaD3OdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:33:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:44805 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759086AbaD3OdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:33:11 -0400
Date: Wed, 30 Apr 2014 10:33:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Nicholas Mc Guire <der.herr@hofr.at>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>
Subject: Re: [ANNOUNCE] 3.14-rt1
Message-ID: <20140430103308.1e46dd18@gandalf.local.home>
In-Reply-To: <20140430101919.70b2f622@gandalf.local.home>
References: <20140411185739.GA6644@linutronix.de>
	<1397918766.5436.16.camel@marge.simpson.net>
	<1398411635.11930.45.camel@marge.simpson.net>
	<1398501491.12941.5.camel@marge.simpson.net>
	<1398520699.28726.22.camel@marge.simpson.net>
	<1398661784.30930.33.camel@marge.simpson.net>
	<1398676186.30930.49.camel@marge.simpson.net>
	<20140428101805.75032f45@gandalf.local.home>
	<1398695832.14475.10.camel@marge.simpson.net>
	<1398748869.5514.81.camel@marge.simpson.net>
	<20140429201308.63292691@gandalf.local.home>
	<1398843793.26071.52.camel@marge.simpson.net>
	<1398863189.26071.97.camel@marge.simpson.net>
	<20140430091550.1177bc90@gandalf.local.home>
	<1398866403.26071.125.camel@marge.simpson.net>
	<20140430101919.70b2f622@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2014 10:19:19 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> I'm testing it now. But could you please post them as regular patches.
> They were attachments to this thread, and were not something that stood
> out.

With your two patches, it still crashes exactly the same way. I
probably should remove my debug just in case, but I think this box has
another problem with it.

-- Steve
