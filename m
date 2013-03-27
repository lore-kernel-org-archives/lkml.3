Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3C0IpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:45:16 -0400
Received: from mail-ia0-f169.google.com ([209.85.210.169]:45438 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3C0IpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:45:14 -0400
MIME-Version: 1.0
In-Reply-To: <1363272864-16183-1-git-send-email-linus.walleij@stericsson.com>
References: <1363272864-16183-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 27 Mar 2013 09:45:13 +0100
Message-ID: <CACRpkdYC92ZrptMGNySpJBwcu5bFAK_KiA_kkQ4qwfypYx-knA@mail.gmail.com>
Subject: Re: [PATCH] mfd: abx500 move the AB8500 Kconfig fragment
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Anmar Oueja <anmar.oueja@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 3:54 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> Move the AB8500 Kconfig fragment below the AB3100 so the
> menuconfig menu gets hierarchically nested and looks nice.
> Having the EZX PCAP in the middle disturbs the nice
> hierarchical layout from kconfig.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> NOTE: it might look like this code is only touching the EZX
> PCAP config fragment, but that is not the semantic effect,
> that affects only the ABx500's.

Ping on this patch.

Yours,
Linus Walleij
