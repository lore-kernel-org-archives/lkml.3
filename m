Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616Ab3IFQHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:07:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3852 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab3IFQHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:07:37 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=BbXNHQx3NekA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=fxhqf5xVK60A:10 a=vTr9H3xdAAAA:8 a=V0doB5RpxmzB2MsOxFYA:9 a=CjuIK1q_8ugA:10 a=DGUv9C6miAAA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Fri, 6 Sep 2013 12:07:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Dave Jones <davej@redhat.com>, Kyle McMartin <kyle@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ftrace 'failed to modify' bug when loading reiserfs.ko
Message-ID: <20130906120736.6ef58106@gandalf.local.home>
In-Reply-To: <CA+5PVA4axYkrb=jCHAuW_W4rzrKtEaBDLtx5TMcCKS9oH0VFqA@mail.gmail.com>
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
	<20130906113439.5e2692bd@gandalf.local.home>
	<CA+5PVA4axYkrb=jCHAuW_W4rzrKtEaBDLtx5TMcCKS9oH0VFqA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Sep 2013 11:46:13 -0400
Josh Boyer <jwboyer@fedoraproject.org> wrote:


> > Fedora should really look into defaulting to syslinux.
> 
> Doesn't support all the usecases we have, and it's not multi-arch.
> Grub2 has warts, but it's all around more flexible.

We should be working on making syslinux work for all cases then.

Grub2 has more than warts, it's a total disaster. I have not found a
single user that likes grub2 (outside of the grub2 developers
themselves).

The "oneshot" booting is totally broken, I could never get it to work
consistently, thus I had to abandon it for ktest. Grub2 may be
flexible, but it is overly complicated. It's horrible to do anything
but the "default" settings.

-- Steve
