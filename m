Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab3IFPem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 11:34:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29861 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3IFPel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 11:34:41 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=BbXNHQx3NekA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=fxhqf5xVK60A:10 a=20KFwNOVAAAA:8 a=4XW8wOn_gp2J_b4xAucA:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Fri, 6 Sep 2013 11:34:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Kyle McMartin <kyle@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ftrace 'failed to modify' bug when loading reiserfs.ko
Message-ID: <20130906113439.5e2692bd@gandalf.local.home>
In-Reply-To: <20130906152221.GA29715@redhat.com>
References: <20130905212834.605408a4@gandalf.local.home>
	<20130906013455.GA10073@redhat.com>
	<20130905214455.101c6347@gandalf.local.home>
	<20130906014859.GB10073@redhat.com>
	<20130905215154.74c55e9a@gandalf.local.home>
	<20130906035827.GA13446@redhat.com>
	<20130906093252.02c748f5@gandalf.local.home>
	<20130906141852.GA18708@redhat.com>
	<20130906102413.2e52d337@gandalf.local.home>
	<20130906144113.GC25882@merlin.infradead.org>
	<20130906152221.GA29715@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Sep 2013 11:22:21 -0400
Dave Jones <davej@redhat.com> wrote:

> Ugh, it's actually because my local install kernel script calls
> grub2-mkconfig after installing a kernel to clean out old ones and not
> clutter up the boot menu. (Which in turn scans every disk using os-prober[*])

Fedora should really look into defaulting to syslinux.


> 
> Don't waste time on this Steve, I'll just work around it somehow.

I wont.

Thanks,

-- Steve
