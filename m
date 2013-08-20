Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006Ab3HTMDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:03:17 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:38150 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3HTMDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:03:16 -0400
Date: Tue, 20 Aug 2013 13:03:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Florian Lobmaier <florian.lobmaier@ams.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 2/4] mfd: as3722: introduce core driver file
Message-ID: <20130820120311.GL23699@lee--X1>
References: <1376997210-32631-1-git-send-email-florian.lobmaier@ams.com>
 <1376997210-32631-3-git-send-email-florian.lobmaier@ams.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1376997210-32631-3-git-send-email-florian.lobmaier@ams.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013, Florian Lobmaier wrote:

> 
> Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>
> ---
>  drivers/mfd/as3722-core.c |  747 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 747 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/as3722-core.c

This patch needs to be broken down quite a lot. First add the very
basic probe()ing and remove()ing code. Just enough to turn the device
on and do a version check etc.

Then in the next patch, allocate your resources, or a similar
activity. Then patch by patch, build it up do what it is now. Attempt
to add the headers at the appropriate times too. Although, if you
don't know what they all do, I won't be too stringent on that. Just
make sure that you don't add any regmap headers before you use any
regmap functionality, that kind of thing.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
