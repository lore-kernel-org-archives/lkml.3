Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaAPOSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:18:51 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:30552 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751123AbaAPOSt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:18:49 -0500
Date: Thu, 16 Jan 2014 09:18:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: pavel@pavlinux.ru
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH RT 0/8] Linux 3.2.53-rt76-rc1
Message-ID: <20140116091847.0786c8af@gandalf.local.home>
In-Reply-To: <52D7A93C.9090801@pavlinux.ru>
References: <20140116015824.201732155@goodmis.org>
	<52D7A93C.9090801@pavlinux.ru>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014 13:41:16 +0400
Pavel Vasilyev <pavel@pavlinux.ru> wrote:

> 16.01.2014 05:58, Steven Rostedt пишет:
> > Dear RT Folks,
> > 
> > This is the RT stable review cycle of patch 3.2.53-rt76-rc1.
> 
> Yap..., mainline is 3.2.54 !
> 

Yeah, but I already had the -rt specific changes merged into 3.2.53
before 3.2.54 was released, and then I discovered the cpu hotplug bug.
I did not want to release that -rc until it was solved. Now that it is,
I can release this one and then move to 3.2.54.

Thanks,

-- Steve
