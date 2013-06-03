Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab3FCHEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 03:04:01 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35389 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3FCHDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 03:03:55 -0400
MIME-Version: 1.0
In-Reply-To: <1369992439-5421-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <CACRpkdZbCytqaWTK7HvfU2aMpPQVZWX2uf-NXL-rUPGJ6DQ-mQ@mail.gmail.com>
	<1369992439-5421-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Mon, 3 Jun 2013 09:03:54 +0200
Message-ID: <CACRpkdaPA52E--eY_GHCi7rACzXzQKnqSQWsu-N6y_h7mtTuAg@mail.gmail.com>
Subject: Re: [PATCH v1.1] gpiolib: append SFI helpers for GPIO API
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Cohen <david.a.cohen@intel.com>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 11:27 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:

> To support some (legacy) firmwares and platforms let's make life easier for
> their customers.
>
> This patch extracts SFI GPIO API from arch/x86/platform/mrst/mrst.c.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Len Brown <len.brown@intel.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> ---
> Since v1:
>  - address Linus' comments: self-descriptive error codes, removal of __init in
>    header, better title in c-file.

I'm happy with this.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
