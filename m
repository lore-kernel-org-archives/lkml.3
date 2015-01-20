Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbbATMh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:37:59 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:52540 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbbATMh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:37:58 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1501201103360.5526@nanos>
References: <1421658254-22042-1-git-send-email-kuleshovmail@gmail.com>
	<alpine.DEB.2.11.1501201103360.5526@nanos>
Date: Tue, 20 Jan 2015 18:37:57 +0600
Message-ID: <CANCZXo6e4VWtUq=i=3GFjnzd1j3xJ7f-OkOGst41ob5350tucg@mail.gmail.com>
Subject: Re: [PATCH 0/2] x86: earlyprintk cleanup
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

2015-01-20 16:29 GMT+06:00 Thomas Gleixner <tglx@linutronix.de>:
> On Mon, 19 Jan 2015, Alexander Kuleshov wrote:
>
>> The following two patches remove unused macro definitions from
>> early_serial_console and early_printk x86 code.
>
> Sigh. These mechanical 'follow the output of some code analyzer'
> changes are really horrible.
>
> Why not doing the obvious: Move the duplicated defines into a common
> header file and be done with it?
>
> And if you look deeper, then you'll notice that those defines are used
> in two other files as well.
>
> What's worse is that the whole set of defines is readily available in
> include/uapi/linux/serial_reg.h already (just with different symbols).
>
> So what's the point of these removal patches?
>

To get rid of unused code. Will it be better to move general serial
definitions to the arch/x86/include/asm/serial.h? Or it is wrong
place...

Thank you.
