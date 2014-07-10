Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaGJTMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 15:12:46 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:49342 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbaGJTMo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 15:12:44 -0400
MIME-Version: 1.0
In-Reply-To: <2093681.h3dgJ8rFNA@calvin>
References: <CADpTngUm7d88RJS9OV=64t6QrJU4r3M_Z8eV1QYWPeeB5SX5-w@mail.gmail.com>
	<20140710085208.GD12054@laptop.lan>
	<20140710085448.GE12054@laptop.lan>
	<2093681.h3dgJ8rFNA@calvin>
Date: Thu, 10 Jul 2014 21:12:44 +0200
Message-ID: <CABPqkBTu9vk_wsmYVrO6OOxgbwsLDG-A8f7dzutKwYXmoGsqnw@mail.gmail.com>
Subject: Re: WARNING: CPU: 2 PID: 1 at arch/x86/mm/ioremap.c:171 __ioremap_caller+0x290/0x2fa()
From: Stephane Eranian <eranian@google.com>
To: Fabio Coatti <fabio.coatti@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 2:13 PM, Fabio Coatti <fabio.coatti@gmail.com> wrote:
> In data giovedì 10 luglio 2014 10:54:48, Peter Zijlstra ha scritto:
>> On Thu, Jul 10, 2014 at 10:52:08AM +0200, Peter Zijlstra wrote:
>> > On Thu, Jul 10, 2014 at 10:44:21AM +0200, Peter Zijlstra wrote:
>> > > On Wed, Jul 09, 2014 at 12:48:05PM -0700, Fabio Coatti wrote:
>> > > > In data mercoledì 9 luglio 2014 11:54:21, Greg Kroah-Hartman ha
> scritto:
>> > > > > Try cc:ing everyone on that patch, with the original information you
>> > > > > provided, and the linux-kernel mailing list.  Those developers
>> > > > > should be
>> > > > > able to help you out properly.
>> > > >
>> > > > Ok, here you can find the description of a problem that I'm
>> > > > experiencing on
>> > > > latest kernels, since 3.15.0.  (this report comes from 3.15.4)
>> > > >
>> > > > lug 07 22:08:00 calvin kernel: resource map sanity check conflict:
>> > > > 0xfed10000 0xfed15fff 0xfed10000 0xfed13fff reserved
>> > > > lug 07 22:08:00 calvin kernel: ------------[ cut here ]------------
>> > >
>> > > I think this is a 'known' issue on Thinkpad (iirc). For some obscure
>> > > reason its BIOS has funny ideas about resources etc.
>> > >
>> > > I couldn't quickly find the prvious thread, maybe Stephane knows.
>> >
>> > Found it:
>> >   lkml.kernel.org/r/20140224162400.GE16457@pd.tnic
>>
>> Ok, reread that thread and no definite conclusion was found I think.
>> Just Thinkpad firmware having overlapping resources.
>
>
> So I guess that this happens also for HP Folio 9470m, not only in thinkpads. I
> wonder how many machines shares this behaviour...
>
Somehow, I thought that Bjorn had proposed a fix for this.
