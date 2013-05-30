Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965451Ab3E3RV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 13:21:58 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:65048 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965173Ab3E3RVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 13:21:51 -0400
MIME-Version: 1.0
In-Reply-To: <1369218014-28990-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369218014-28990-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1369218014-28990-3-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 30 May 2013 19:21:50 +0200
Message-ID: <CACRpkdbzc4TEnbOajsvVebWcCek+Lh2JnpFKhJwmCJe9H1Gf1Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] gpio-langwell: do not use direct access to
 iomapped memory
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

> We better to use readl() function instead of bad looking direct access.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Patch applied.

Yours,
Linus Walleij
