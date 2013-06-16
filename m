Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab3FPLDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 07:03:11 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:49018 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920Ab3FPLDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 07:03:10 -0400
MIME-Version: 1.0
In-Reply-To: <1370795767-9769-3-git-send-email-maxime.ripard@free-electrons.com>
References: <1370795767-9769-1-git-send-email-maxime.ripard@free-electrons.com>
	<1370795767-9769-3-git-send-email-maxime.ripard@free-electrons.com>
Date: Sun, 16 Jun 2013 13:03:09 +0200
Message-ID: <CACRpkdajdrcLy6u2cKkrpYnh0Hqx8Hjx+zJ_tfpYCfJFqWCrZA@mail.gmail.com>
Subject: Re: [PATCH 2/6] pinctrl: sunxi: Move the pins definitions to a
 separate header
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 9, 2013 at 6:36 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> It will allow us to have a cleaner separation between the data needed by
> the driver to work, and the core logic of the driver in itself, and will
> allow having too much noise in the core driver in the future.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Patch applied.

Since you will anyway have to bring the ARM SoC branch on
top of the pinctrl tree, I might as well apply this to my tree.

If everything else fails, you'll have a nice development base
in v3.11 with this in place, right?

Yours,
Linus Walleij
