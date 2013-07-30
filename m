Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab3G3SO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:14:56 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:56300 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582Ab3G3SOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:14:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130730180230.GJ18151@rocoto.smurfnet.nu>
References: <1375202858-28470-1-git-send-email-leif.lindholm@linaro.org>
	<1375202858-28470-2-git-send-email-leif.lindholm@linaro.org>
	<CA+8MBbK5S3z+VQhhuT5WT7=7zYy=5zyvZEWfnfTfc1NxXBa=Sg@mail.gmail.com>
	<20130730180230.GJ18151@rocoto.smurfnet.nu>
Date: Tue, 30 Jul 2013 11:14:51 -0700
Message-ID: <CA+8MBbLbsrH=gNJ4oc5VzphY6xFMthWoq5R905Rzaow2SmA9uw@mail.gmail.com>
Subject: Re: [PATCH 1/4] efi: provide a generic efi_config_init()
From: Tony Luck <tony.luck@gmail.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 11:02 AM, Leif Lindholm
<leif.lindholm@linaro.org> wrote:
> So I guess the clean way to deal with that would be to make the
> memremap definition a separate patch?

Or just pull:
+#define early_memremap(phys_addr, size)        early_ioremap(phys_addr, size)
out of part 3 and put it into part1 (along with some of the commit commentary).

-Tony
