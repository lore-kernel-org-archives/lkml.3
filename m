Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729Ab3IFQki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:40:38 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:55245 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab3IFQkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:40:33 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA6=jbzzjHJcE=CE6Eu+YtOCU+VN8ttraxL_pzQauRrSXA@mail.gmail.com>
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
	<CA+5PVA6=jbzzjHJcE=CE6Eu+YtOCU+VN8ttraxL_pzQauRrSXA@mail.gmail.com>
Date: Fri, 6 Sep 2013 18:40:32 +0200
Message-ID: <CAFLxGvziE4dp1UOoSKqeUcPUwv8V2eT1hVgC6tbsfkHUSkS4rg@mail.gmail.com>
Subject: Re: ftrace 'failed to modify' bug when loading reiserfs.ko
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Kyle McMartin <kyle@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 6:12 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> On Fri, Sep 6, 2013 at 12:07 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> On Fri, 6 Sep 2013 11:46:13 -0400
>> Josh Boyer <jwboyer@fedoraproject.org> wrote:
>>
>>
>>> > Fedora should really look into defaulting to syslinux.
>>>
>>> Doesn't support all the usecases we have, and it's not multi-arch.
>>> Grub2 has warts, but it's all around more flexible.
>>
>> We should be working on making syslinux work for all cases then.
>
> Is there something stopping you? :)  More specifically, I don't think
> syslinux will ever support e.g. powerpc or ARM (Aarch64) so it doesn't
> seem like a general purpose solution.  I could be wrong.

Is there a list of use cases which are missing in syslinux?

On all systems where I have to touch the bootloader
(running custom kernels, using one-shot, ...) I always install
gummiboot or syslinux because
grub2 sucks so much. grub1 worked quite well but grub2 is a PITA.

-- 
Thanks,
//richard

P.s: Sorry for flaming but gub2 disappointed me more than once.
