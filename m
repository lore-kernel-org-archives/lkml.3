Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964838AbaD2LKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:10:36 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:21987 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933004AbaD2LKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:10:35 -0400
Date: Tue, 29 Apr 2014 12:09:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 0/7] Generic serial earlycon
Message-ID: <20140429110950.GF17007@arm.com>
References: <1397859600-11507-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397859600-11507-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 11:19:53PM +0100, Rob Herring wrote:
> Rob Herring (7):
>   x86: move FIX_EARLYCON_MEM kconfig into x86
>   tty/serial: add generic serial earlycon
>   tty/serial: convert 8250 to generic earlycon
>   tty/serial: pl011: add generic earlycon support
>   tty/serial: add arm/arm64 semihosting earlycon
>   arm64: enable FIX_EARLYCON_MEM kconfig
>   arm64: remove arch specific earlyprintk

The series looks fine, you can add:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

BTW, are you merging all of them via some other tree or would prefer me
to take the arm64-specific patches?
