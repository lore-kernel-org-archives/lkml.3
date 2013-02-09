Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab3BINi1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 08:38:27 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:62952 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab3BINiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 08:38:25 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3] gpio: vt8500: memory cleanup missing
To: Tony Prisk <linux@prisktech.co.nz>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
In-Reply-To: <1358485102-6585-1-git-send-email-linux@prisktech.co.nz>
References: <1358485102-6585-1-git-send-email-linux@prisktech.co.nz>
Date: Sat, 09 Feb 2013 13:38:21 +0000
Message-Id: <20130209133821.5FDC93E30EC@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2013 17:58:22 +1300, Tony Prisk <linux@prisktech.co.nz> wrote:
> This driver is missing a .remove callback, and the fail path on
> probe is incomplete.
> 
> If an error occurs in vt8500_add_chips, gpio_base is not unmapped.
> The driver is also ignoring the return value from this function so
> if a chip fails to register it completes as successful.
> 
> Replaced pr_err with dev_err in vt8500_add_chips since the device is
> available.
> 
> There is also no .remove callback defined so the function is added.
> 
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>

Applied, thanks.

g.

