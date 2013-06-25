Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab3FYT2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:28:40 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:33947 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3FYT2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 15:28:39 -0400
MIME-Version: 1.0
In-Reply-To: <51C9EADD.5000904@zytor.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
	<20130621165142.GA32125@kroah.com>
	<51C48745.9030304@zytor.com>
	<CAE9FiQX3Opcv0E7+PXNAUoJtgoa0Cxv5wOK=R_ERvQjN79poXQ@mail.gmail.com>
	<20130621185056.GA23473@kroah.com>
	<51C4C5F3.3050800@sgi.com>
	<CAE9FiQXaUNbK9+g-7j6gfvLrSvUJFWWKapDv658LPe4VfbH=tQ@mail.gmail.com>
	<51C9D4ED.5070805@sgi.com>
	<51C9DEC1.6030602@zytor.com>
	<CAE9FiQV5z+3AXy5c=aaU3vq1V3fibJ6PhhA4VW5H8BWVzhxXPA@mail.gmail.com>
	<51C9E523.7000803@zytor.com>
	<51C9E83A.8070700@sgi.com>
	<CAE9FiQUckP6m-HTdzdAJt0P_1bok-QHrxqm3RUTx=v_C=ufFCg@mail.gmail.com>
	<51C9EADD.5000904@zytor.com>
Date: Tue, 25 Jun 2013 12:28:38 -0700
X-Google-Sender-Auth: dAESfGFP0UAhO8qRXEeLaZSX3YE
Message-ID: <CAE9FiQU1kGVNYZ+XUFDG=OaPSZskSOHP8mf0f=pQGEGFd7Yfbw@mail.gmail.com>
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>, Nathan Zimmer <nzimmer@sgi.com>,
        Robin Holt <holt@sgi.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 12:09 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> According to Intel SDM, CPU could support 52bits physical addressing.
>>
>> So how linux kernel will handle it? as we only have 48bits virtual addressing.
>>
>
> The Linux kernel will not support more than V-2 bits of physical address
> space for any number V of virtual address bits.

ok, then will need cpu support 57bits virtual addressing, and level 5
page table?

Yinghai
