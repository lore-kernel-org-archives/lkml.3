Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965517Ab3E3R1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 13:27:24 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:61273 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965173Ab3E3R1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 13:27:18 -0400
MIME-Version: 1.0
In-Reply-To: <1369218014-28990-5-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369218014-28990-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1369218014-28990-5-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 30 May 2013 19:27:17 +0200
Message-ID: <CACRpkdZWsMyuvK1s4SOnVVRrT0QAJXYmQiToAQRKow4YD1mMug@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] gpio-langwell: amend error messages
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

> There is no need to use hardcoded device name in the error messages, because
> dev_err() prefixes the message with the device name anyway.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Patch applied.

Yours,
Linus Walleij
