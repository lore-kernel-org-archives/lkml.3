Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbaAaISL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 03:18:11 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:41642 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbaAaISK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 03:18:10 -0500
MIME-Version: 1.0
In-Reply-To: <1390467453-8841-1-git-send-email-linux@prisktech.co.nz>
References: <1390467453-8841-1-git-send-email-linux@prisktech.co.nz>
Date: Fri, 31 Jan 2014 09:18:09 +0100
Message-ID: <CACRpkdaUJkTrT1=VST76dSxFhkJYhB6hMM_TRkTCYaX58QHp6Q@mail.gmail.com>
Subject: Re: [PATCH v2 RESEND] vt8500: pinctrl: Change devicetree data parsing
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 9:57 AM, Tony Prisk <linux@prisktech.co.nz> wrote:

> Due to an assumption in the VT8500 pinctrl driver, the value passed
> from devicetree for 'wm,pull' was not explicitly translated before
> being passed to pinconf.
>
> Since v3.10, changes to 'enum pin_config_param', PIN_CONFIG_BIAS_PULL_(UP/DOWN)
> no longer map 1-to-1 with the expected values in devicetree.
>
> This patch adds a small translation between the devicetree values (0..2)
> and the enum pin_config_param equivalent values.
>
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
> v2:

Patch applied to fixes and tagged for stable v3.10+

Yours,
Linus Walleij
