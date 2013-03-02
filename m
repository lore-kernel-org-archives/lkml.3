Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab3CCMIB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 07:08:01 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:47382 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab3CCMH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 07:07:56 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: gpio-ich: fix ichx_gpio_check_available() return what callers expect
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Peter Tyser <ptyser@xes-inc.com>,
        Jean Delvare <khali@linux-fr.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
In-Reply-To: <1361978715-14948-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1361978715-14948-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Sat, 02 Mar 2013 09:18:36 +0000
Message-Id: <20130302091836.1DBD83E15E3@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2013 17:25:15 +0200, Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> ichx_gpio_check_available() returns either 0 or -ENXIO depending on whether
> the given GPIO is available or not. However, callers of this function treat
> the return value as boolean:
> 
> 	...
> 	if (!ichx_gpio_check_available(gpio, nr))
> 		return -ENXIO;
> 
> which erroneusly fails when the GPIO is available and not vice versa.
> 
> Fix this by making the function return boolean as expected by the callers.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Applied, thanks.

g.

