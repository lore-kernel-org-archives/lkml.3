Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3A2Tgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 14:36:43 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:53309 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab3A2Tgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 14:36:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWof73nuTTg-hou2iXZQGXfmodiT9BN8Hh-=x4ROEu5jg@mail.gmail.com>
References: <510579C1.3000800@zytor.com>
	<1359313804.10797.74.camel@shinybook.infradead.org>
	<51057DA7.7040907@zytor.com>
	<CAE9FiQUFZwmiBgYwsoLZ4O+f_w-V01Eb8_6L4ZrHeA4DfLJd8A@mail.gmail.com>
	<0023b092-6149-418f-8adc-dd7f5631006c@email.android.com>
	<CAE9FiQWnxQXQgjmEs+Jv=uoYHK-GuP34D1B_5NyJp6Nf6s2sYw@mail.gmail.com>
	<1a8f7aa6-f27a-4237-9be1-1b2c3718e21a@email.android.com>
	<CAE9FiQXwwu7HELhNUMFTMswe=X58+0Jpc7GeEBdhiF9Jcm4o3Q@mail.gmail.com>
	<CAE9FiQWof73nuTTg-hou2iXZQGXfmodiT9BN8Hh-=x4ROEu5jg@mail.gmail.com>
Date: Tue, 29 Jan 2013 11:36:38 -0800
X-Google-Sender-Auth: yRSkXPvV_HonxbJ2Qei-QWLAY4c
Message-ID: <CAE9FiQVL86V96ry5=Gdg8nsyWiGHa4j=WMH_BRdQJomB7j3O1A@mail.gmail.com>
Subject: Re: bzImage 2.12
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 8:22 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Jan 28, 2013 at 7:50 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Sun, Jan 27, 2013 at 7:36 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Did you get chance to put them into for-x86-boot?
>>
>> You need to skip the first two about memmap= exactmap and reserveram ...
>>
>

please check
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-boot for-x86-boot-v7u5

and it is based on Linus tree +  tip:x86/mm2 + tip:x86/boot

Also put Konrad Ack into last swiotlb patch.

Thanks

Yinghai
