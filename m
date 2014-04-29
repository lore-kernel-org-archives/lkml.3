Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbaD2PMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 11:12:38 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:55083 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679AbaD2PMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 11:12:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140429110950.GF17007@arm.com>
References: <1397859600-11507-1-git-send-email-robherring2@gmail.com>
	<20140429110950.GF17007@arm.com>
Date: Tue, 29 Apr 2014 10:12:35 -0500
Message-ID: <CAL_JsqJtXeB55kv7VD4DRj4F2W9HsJ39JFuaDQtocZLzHE_RUw@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] Generic serial earlycon
From: Rob Herring <robherring2@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 6:09 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Fri, Apr 18, 2014 at 11:19:53PM +0100, Rob Herring wrote:
>> Rob Herring (7):
>>   x86: move FIX_EARLYCON_MEM kconfig into x86
>>   tty/serial: add generic serial earlycon
>>   tty/serial: convert 8250 to generic earlycon
>>   tty/serial: pl011: add generic earlycon support
>>   tty/serial: add arm/arm64 semihosting earlycon
>>   arm64: enable FIX_EARLYCON_MEM kconfig
>>   arm64: remove arch specific earlyprintk
>
> The series looks fine, you can add:
>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>

Thanks.

> BTW, are you merging all of them via some other tree or would prefer me
> to take the arm64-specific patches?

Greg has taken it, but there were a few issues, so it may get reposted.

Rob
