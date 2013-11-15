Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3KOGzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 01:55:38 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:50285 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab3KOGz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 01:55:29 -0500
MIME-Version: 1.0
In-Reply-To: <20131115062417.GB9237@gmail.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
	<d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com>
	<20131113224503.GB25344@anatevka.fc.hp.com>
	<52840206.5020006@zytor.com>
	<20131113235708.GC25344@anatevka.fc.hp.com>
	<CAOJsxLFkHQ6_f+=CMwfNLykh59TZH5VrWeVEDPCWPF1wiw7tjQ@mail.gmail.com>
	<20131114180455.GA32212@anatevka.fc.hp.com>
	<CAOJsxLFWMi8DoFp+ufri7XoFO27v+2=0oksh8+NhM6P-OdkOwg@mail.gmail.com>
	<20131115005049.GJ5116@anatevka.fc.hp.com>
	<20131115062417.GB9237@gmail.com>
Date: Thu, 14 Nov 2013 22:55:28 -0800
X-Google-Sender-Auth: BxgS98HAly3yaCEfQuYoOGHdQhs
Message-ID: <CAE9FiQWzSTtW8N=0hoUe6iCSM-k64Mv97n0whAS0_vZ+psuOsg@mail.gmail.com>
Subject: Re: [PATCH 0/3] Early use of boot service memory
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: jerry.hoemann@hp.com, Pekka Enberg <penberg@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86 maintainers <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "list@ebiederm.org:DOCUMENTATION <linux-doc@vger.kernel.org>,
	list@ebiederm.org:MEMORY MANAGEMENT <linux-mm@kvack.org>," 
	<linux-doc@vger.kernel.org>,
        linux-efi@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 10:24 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * jerry.hoemann@hp.com <jerry.hoemann@hp.com> wrote:
>
>> On Thu, Nov 14, 2013 at 08:44:04PM +0200, Pekka Enberg wrote:
>> > On Thu, Nov 14, 2013 at 8:04 PM,  <jerry.hoemann@hp.com> wrote:
>> > > Making this issue a quirk will be a lot more practical.  Its a small, focused
>> > > change whose implications are limited and more easily understood.
>> >
>> > There's nothing practical with requiring users to pass a kernel option
>> > to make kdump work.  It's a workaround, sure, but it's not a proper
>> > fix.
>>
>> One already has to specify command line arguments to enable kdump.
>> See "crashkernel=" in Documentation/kernel-parameters.txt.
>
>> As i said in an earlier mail we are working w/ distros. [...]

Why just asking distros to append ",high" in their installation
program for 64bit by default?

If they don't want to do that, you can add instruction in your product notes, to
ask user/admin to add that if kdump fails.

>
>
>> As i said in earlier mail, i am willing to change implementation to
>> some type of black/white listing.
>
> Is it possible to fix it the way hpa suggested?
>

What is hpa's suggestion?

Yinghai
