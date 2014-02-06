Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbaBFMsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 07:48:14 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:47430 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326AbaBFMsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 07:48:13 -0500
MIME-Version: 1.0
In-Reply-To: <1391583082-314-1-git-send-email-florian.vaussard@epfl.ch>
References: <1391583082-314-1-git-send-email-florian.vaussard@epfl.ch>
Date: Thu, 6 Feb 2014 13:48:12 +0100
Message-ID: <CACRpkdatZQeh7mzfbtcrj+ksMP3uyQbMkB66R=V0KOUpY3CJRA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: do not init debugfs entries for unimplemented functionalities
From: Linus Walleij <linus.walleij@linaro.org>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 5, 2014 at 7:51 AM, Florian Vaussard
<florian.vaussard@epfl.ch> wrote:

> Commit c420619 "pinctrl: pinconf: remove checks on ops->pin_config_get"
> removed the check on (ops != NULL) when performing pinconf_pins_show() or
> pinconf_groups_show(). As these entries are always enabled, even if
> pinconf is not supported, reading will result in an oops due to NULL
> ops.
>
> Instead of checking for ops, remove the corresponding debugfs entries if
> pinconf and/or pinmux are not implemented.
>
> Tested on OMAP3 (pinctrl-single).
>
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>

Oh that was an elegant fix, thanks!
Patch applied for fixes, tagged for stable.

Yours,
Linus Walleij
