Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbaD1NkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:40:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:53964 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932096AbaD1NkF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:40:05 -0400
Date: Mon, 28 Apr 2014 09:39:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: pavel@pavlinux.ru
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH RT 0/3] Linux 3.2.57-rt84-rc1
Message-ID: <20140428093956.78d0f3ea@gandalf.local.home>
In-Reply-To: <535D8180.1020607@pavlinux.ru>
References: <20140427143925.177486597@goodmis.org>
	<535D8180.1020607@pavlinux.ru>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2014 02:15:28 +0400
Pavel Vasilyev <pavel@pavlinux.ru> wrote:

> 27.04.2014 18:39, Steven Rostedt пишет:
> > Dear RT Folks,
> >
> > This is the RT stable review cycle of patch 3.2.57-rt84-rc1.
> >
> > Please scream at me if I messed something up. Please test the patches too.
> 
> 
> More than two years our thin clients (about 5000 machines, Intel Atom, x86_32) 
> work with RCU_BOOST.
> 
> CONFIG_RCU_BOOST=y
> CONFIG_RCU_BOOST_PRIO=80
> CONFIG_RCU_BOOST_DELAY=400
> 

Is this just a confirmation of having RCU_BOOST default y for
PREEMPT_RT is a good thing?

Thanks,

-- Steve
