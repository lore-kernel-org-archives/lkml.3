Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934747AbaGPRYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:24:19 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:40555 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965263AbaGPRYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:24:15 -0400
Date: Wed, 16 Jul 2014 13:24:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: <balbi@ti.com>
Cc: <will.deacon@arm.com>, <mingo@redhat.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: Function Profiler broken on today's linux-next
Message-ID: <20140716132413.1ede8e1d@gandalf.local.home>
In-Reply-To: <20140716164141.GA3016@saruman.home>
References: <20140716162328.GJ1365@saruman.home>
	<20140716122921.71b118a9@gandalf.local.home>
	<20140716164141.GA3016@saruman.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2014 11:41:42 -0500
Felipe Balbi <balbi@ti.com> wrote:


> .config attached. It's actually an ARM platform, I can help out with
> testing anything you need.

In that case, can you see if it works under my repo?

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
branch: ftrace/core

Thanks,

-- Steve

