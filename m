Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbaGAB7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 21:59:19 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:39663 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaGAB7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 21:59:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140630094157.GT32514@n2100.arm.linux.org.uk>
References: <1404096760-5239-1-git-send-email-xerofoify@gmail.com>
	<20140630094157.GT32514@n2100.arm.linux.org.uk>
Date: Mon, 30 Jun 2014 21:59:17 -0400
Message-ID: <CAPDOMVjNU+XJnxqVsY5ZAh=VUx8RUf_Av0C8yVdaTczQWsh-ng@mail.gmail.com>
Subject: Re: [PATCH] Fixes gemmi_idle in file idle.c
From: Nick Krause <xerofoify@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: ulli.kroll@googlemail.com, linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the good feedback on kernel development , I will delete this file
in order to clean up race conditions caused by it.
Cheers Nick

On Mon, Jun 30, 2014 at 5:41 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Jun 29, 2014 at 10:52:40PM -0400, Nicholas Krause wrote:
>> disables the IRQ line in gemmi_idle before calling cpu_do_idle.
>> In addition, according to the Fixme message in this file fixes
>> races that may occur due to not disabling the IRQ before calling
>> cpu_do_idle.
>
> 1) the idle method is called with interrupts already disabled.
> 2) I wonder if you read the comment above the comment you removed, and
>    if so, why it wasn't removed.
> 3) can you indicate how the hardware problem has been fixed, or give some
>    justification why this change should be accepted.
>
> --
> FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
> improving, and getting towards what was expected from it.
