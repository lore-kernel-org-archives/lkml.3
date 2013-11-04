Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab3KDMFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 07:05:21 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:63193 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3KDMFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 07:05:20 -0500
MIME-Version: 1.0
In-Reply-To: <1382940076-11898-1-git-send-email-peter.chen@freescale.com>
References: <1382940076-11898-1-git-send-email-peter.chen@freescale.com>
Date: Mon, 4 Nov 2013 13:05:19 +0100
Message-ID: <CACRpkdboYNgLPh0=HiMyd6e21xjruwzb1PqP69_hL3Ds+wun8g@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: imx: fix using pin->input_val wrongly
From: Linus Walleij <linus.walleij@linaro.org>
To: Peter Chen <peter.chen@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 7:01 AM, Peter Chen <peter.chen@freescale.com> wrote:

> The commit: "pinctrl: imx: Use struct type for pins" relaced
> pin->input_reg by pin->input_val wrongly, fix it at this commit.
>
> Signed-off-by: Peter Chen <peter.chen@freescale.com>

Patch applied with Sascha's ACK.

Yours.
Linus Walleij
