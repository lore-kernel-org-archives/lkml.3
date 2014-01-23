Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbaAWIZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 03:25:29 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49620 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbaAWIZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 03:25:27 -0500
MIME-Version: 1.0
In-Reply-To: <1390360492-29126-1-git-send-email-chris.ruehl@gtsys.com.hk>
References: <1390360492-29126-1-git-send-email-chris.ruehl@gtsys.com.hk>
Date: Thu, 23 Jan 2014 09:25:27 +0100
Message-ID: <CACRpkdYQHOq+q7f7_iaHw6hqt9vGT_2YLCEzDyeBu_i1biRK0g@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] imx27: pinctrl: fix wrong offset to ICONFB
From: Linus Walleij <linus.walleij@linaro.org>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm@lists.infradead.org, Markus Pargmann <mpa@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 4:14 AM, Chris Ruehl <chris.ruehl@gtsys.com.hk> wrote:

> The offset to ICONFB was incorrect, this patch set the correct value 0x14.
> dev_dbg in function imx1_write_2bit print the wrong address and had been
> moved after address calculation.
>
> Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>

Patch applied with Markus' Reveiew tag and
tagged for stable.

Yours,
Linus Walleij
