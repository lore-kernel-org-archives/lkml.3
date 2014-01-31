Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbaAaIUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 03:20:10 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:51063 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaAaIUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 03:20:08 -0500
MIME-Version: 1.0
In-Reply-To: <1390360492-29126-2-git-send-email-chris.ruehl@gtsys.com.hk>
References: <1390360492-29126-1-git-send-email-chris.ruehl@gtsys.com.hk>
	<1390360492-29126-2-git-send-email-chris.ruehl@gtsys.com.hk>
Date: Fri, 31 Jan 2014 09:20:08 +0100
Message-ID: <CACRpkdbkc2dGLnuuBGqw3nrXHcq6gh30qC7Go4X6YBZDa-5wvw@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] imx27: pinctrl: fix offset calculation in imx_read_2bit
From: Linus Walleij <linus.walleij@linaro.org>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm@lists.infradead.org, Markus Pargmann <mpa@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 4:14 AM, Chris Ruehl <chris.ruehl@gtsys.com.hk> wrote:

> The offset for the 2bit register calculate wrong, this patch
> fixes the problem. The debugfs printout for oconf, iconfa, iconfb
> now shows the real values.
>
> Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>

Patch applied for fixes with Markus' Review tag. Also
tagged for stable.

Yours,
Linus Walleij
