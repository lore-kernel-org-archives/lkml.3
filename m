Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965555Ab3E3R25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 13:28:57 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:37629 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965407Ab3E3R2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 13:28:51 -0400
MIME-Version: 1.0
In-Reply-To: <1369218014-28990-6-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369218014-28990-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1369218014-28990-6-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 30 May 2013 19:28:50 +0200
Message-ID: <CACRpkdZByPqf4GtC=R7YqeGM3anKgRCo_njSapeg-TKEJtU2vA@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] gpio-langwell: drop away explicit casting
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

> Since the type of the reg_base member is void __iomem * we don't need to have
> explicit casting in gpio_reg() and gpio_reg_2bit().
>
> Update year in the copyright notice as well.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Patch applied with Mika's ACK.

Yours,
Linus Walleij
