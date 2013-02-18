Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab3BRRNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 12:13:40 -0500
Received: from mail-ia0-f180.google.com ([209.85.210.180]:54877 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab3BRRNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:13:38 -0500
MIME-Version: 1.0
In-Reply-To: <CANuKePkED+JD1FKBorP3ye3sMDEKJh6Gq+4_qt_0OH+gPni3TQ@mail.gmail.com>
References: <CAE9FiQVT7Q1=NOcTvzkmskQLpfvuX+JSW_9NBXjx7z77TDHz3Q@mail.gmail.com>
	<1360263182-16226-1-git-send-email-yinghai@kernel.org>
	<CANuKePkED+JD1FKBorP3ye3sMDEKJh6Gq+4_qt_0OH+gPni3TQ@mail.gmail.com>
Date: Mon, 18 Feb 2013 09:13:36 -0800
X-Google-Sender-Auth: nzQDWjmD4t4phRVQIkZSTjaAtdQ
Message-ID: <CAE9FiQW4wt18d6ODfM+deuMfxGeqiP3GkGVtXmOuWX+d1tGPoA@mail.gmail.com>
Subject: Re: [PATCH v4] x86, apic: Check fadt x2apic phys in x2apic_phys_probe()
From: Yinghai Lu <yinghai@kernel.org>
To: Lin-Bao Zhang <2004.zhang@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Stoney Wang <song-bo.wang@hp.com>, stable@kernel.org,
        linbao.zhang@hp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 12:52 AM, Lin-Bao Zhang <2004.zhang@gmail.com> wrote:
> Hi Yinghai ,
> this patch has been committed into some git repository ? if yes ,
> which repository ?
> I just " git log arch/x86/kernel/apic/x2apic_phys.c " on
> "linux-stable" , but I could not find it.
> i guess maybe you will put it into another repository ,thanks very much!

It is already in linus's tree.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=cb214ede7657db458fd0b2a25ea0b28dbf900ebc

Stable tree should have that soon.

Thanks

Yinghai
