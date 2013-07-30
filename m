Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab3G3T5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 15:57:54 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:57543 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab3G3T5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 15:57:51 -0400
MIME-Version: 1.0
In-Reply-To: <1375202858-28470-1-git-send-email-leif.lindholm@linaro.org>
References: <1375202858-28470-1-git-send-email-leif.lindholm@linaro.org>
Date: Tue, 30 Jul 2013 12:57:49 -0700
Message-ID: <CA+8MBb+VzakCg0NAfxTxQ+LipvKhjTL4QaU5Q-vEU=hVZViq_A@mail.gmail.com>
Subject: Re: [PATCH 0/4] Make commonly useful UEFI functions common
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

On Tue, Jul 30, 2013 at 9:47 AM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> IA64 code compile tested only.

Compiled on a bunch of ia64 configurations, Boot tested. But not on machine that
does the PROCESSOR_ABSTRACTION_LAYER_OVERWRITE_GUID thingy.
Code to do the arch specific thing looks ok though.

-Tony
