Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717Ab3IFQMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:12:50 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:64024 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab3IFQMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:12:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130906120736.6ef58106@gandalf.local.home>
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
	<20130906120736.6ef58106@gandalf.local.home>
Date: Fri, 6 Sep 2013 12:12:48 -0400
X-Google-Sender-Auth: AbMKvm49x9qni_VGUqewx_jnDcM
Message-ID: <CA+5PVA6=jbzzjHJcE=CE6Eu+YtOCU+VN8ttraxL_pzQauRrSXA@mail.gmail.com>
Subject: Re: ftrace 'failed to modify' bug when loading reiserfs.ko
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>, Kyle McMartin <kyle@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 12:07 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 6 Sep 2013 11:46:13 -0400
> Josh Boyer <jwboyer@fedoraproject.org> wrote:
>
>
>> > Fedora should really look into defaulting to syslinux.
>>
>> Doesn't support all the usecases we have, and it's not multi-arch.
>> Grub2 has warts, but it's all around more flexible.
>
> We should be working on making syslinux work for all cases then.

Is there something stopping you? :)  More specifically, I don't think
syslinux will ever support e.g. powerpc or ARM (Aarch64) so it doesn't
seem like a general purpose solution.  I could be wrong.

> Grub2 has more than warts, it's a total disaster. I have not found a
> single user that likes grub2 (outside of the grub2 developers
> themselves).
>
> The "oneshot" booting is totally broken, I could never get it to work
> consistently, thus I had to abandon it for ktest. Grub2 may be
> flexible, but it is overly complicated. It's horrible to do anything
> but the "default" settings.

We have essentially one person working on bootloaders and that person
has to support them in RHEL too.  I'm sure they'd appreciate help.

josh
