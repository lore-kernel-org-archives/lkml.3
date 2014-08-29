Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaH2FC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 01:02:58 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:49685 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbaH2FC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 01:02:57 -0400
MIME-Version: 1.0
In-Reply-To: <1407771493-19581-1-git-send-email-kiran.padwal@smartplayin.com>
References: <1407771493-19581-1-git-send-email-kiran.padwal@smartplayin.com>
Date: Fri, 29 Aug 2014 07:02:56 +0200
Message-ID: <CACRpkdY2tiPuBQjHKNz5T9wOmMeaLmpPfz7-L8Z-Bv_2ruqSfg@mail.gmail.com>
Subject: Re: [PATCH 04/11] pinctrl: imx28: Make of_device_id array const
From: Linus Walleij <linus.walleij@linaro.org>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 5:38 PM, Kiran Padwal
<kiran.padwal@smartplayin.com> wrote:

> Make of_device_id array const, because all OF functions handle it as const.
> ---
>  drivers/pinctrl/pinctrl-imx28.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Yours,
Linus Walleij
