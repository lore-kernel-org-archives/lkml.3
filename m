Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965489Ab3E3R0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 13:26:03 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:55638 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965173Ab3E3RZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 13:25:58 -0400
MIME-Version: 1.0
In-Reply-To: <1369218014-28990-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369218014-28990-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1369218014-28990-4-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 30 May 2013 19:25:58 +0200
Message-ID: <CACRpkdYE+Gy5N62HWrEFiQ-eThMBm8xubLv7-C_XLMXxGNunEQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] gpio-langwell: use managed functions pcim_* and devm_*
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: David Cohen <david.a.cohen@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 12:20 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:

> This makes the error handling much more simpler than open-coding everything and
> in addition makes the probe function smaller an tidier.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Applied with Mika's ACK.

I had to rebase this thing since there was a patch removing the line
setting platform data to NULL on remove(), check that I did the right
thing in the result.

Yours,
Linus Walleij
