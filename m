Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3IFPqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 11:46:18 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:33176 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab3IFPqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 11:46:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130906113439.5e2692bd@gandalf.local.home>
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
Date: Fri, 6 Sep 2013 11:46:13 -0400
X-Google-Sender-Auth: eJC7Ddyu09dgvG0QqPiuuresiyg
Message-ID: <CA+5PVA4axYkrb=jCHAuW_W4rzrKtEaBDLtx5TMcCKS9oH0VFqA@mail.gmail.com>
Subject: Re: ftrace 'failed to modify' bug when loading reiserfs.ko
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>, Kyle McMartin <kyle@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 11:34 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 6 Sep 2013 11:22:21 -0400
> Dave Jones <davej@redhat.com> wrote:
>
>> Ugh, it's actually because my local install kernel script calls
>> grub2-mkconfig after installing a kernel to clean out old ones and not
>> clutter up the boot menu. (Which in turn scans every disk using os-prober[*])
>
> Fedora should really look into defaulting to syslinux.

Doesn't support all the usecases we have, and it's not multi-arch.
Grub2 has warts, but it's all around more flexible.

josh
