Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab3C0IWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:22:24 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:41781 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab3C0IWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:22:21 -0400
MIME-Version: 1.0
In-Reply-To: <1362646099-3506-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1362646099-3506-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Wed, 27 Mar 2013 09:22:20 +0100
Message-ID: <CACRpkdYMC6zpQ7ioPoMScAgNdoi+eg+ViBpy5_X6+4ySbBbiHQ@mail.gmail.com>
Subject: Re: [PATCH] gpio/gpio-ich: make ichx_gpio_check_available() return a
 pure boolean value
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Peter Tyser <ptyser@xes-inc.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 9:48 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> It is more readable for humans to use double-bang (!!) to convert the value
> to pure boolean before it is returned.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Thanks, patch applied!

Yours,
Linus Walleij
