Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaDZGUD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 02:20:03 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:46342 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaDZGUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 02:20:00 -0400
MIME-Version: 1.0
In-Reply-To: <1397859600-11507-4-git-send-email-robherring2@gmail.com>
References: <1397859600-11507-1-git-send-email-robherring2@gmail.com>
	<1397859600-11507-4-git-send-email-robherring2@gmail.com>
Date: Fri, 25 Apr 2014 23:19:59 -0700
X-Google-Sender-Auth: 5pA72wSVcxqNj-HghigxiaXfB1c
Message-ID: <CAE9FiQVrwypK4u5yTCt-AxMuBnOn7jv=V3d4Zb3cd9JDNEUVPw@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] tty/serial: convert 8250 to generic earlycon
From: Yinghai Lu <yinghai@kernel.org>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 3:19 PM, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <robh@kernel.org>
>
> With the generic earlycon infrastructure in place, convert the 8250
> early console to use it.
>
> Signed-off-by: Rob Herring <robh@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> ---
>  drivers/tty/serial/8250/8250_early.c | 138 ++++-------------------------------
>  drivers/tty/serial/8250/Kconfig      |   1 +
>  2 files changed, 16 insertions(+), 123 deletions(-)

Hi Greg, Rob

This one in tty-next breaks booting: "console=uart8250,io,0x3f8,115200".
No early console and regular console anymore.

It should produce "early con and regular con".

Thanks

Yinghai
