Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaH2FEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 01:04:46 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:36967 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaH2FEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 01:04:45 -0400
MIME-Version: 1.0
In-Reply-To: <1407771557-19665-1-git-send-email-kiran.padwal@smartplayin.com>
References: <1407771557-19665-1-git-send-email-kiran.padwal@smartplayin.com>
Date: Fri, 29 Aug 2014 07:04:45 +0200
Message-ID: <CACRpkdaW4ZnNANGJhPxdOofyXhCifuAoE-7p9D1Vp8TwnfhzfA@mail.gmail.com>
Subject: Re: [PATCH 06/11] pinctrl: imx50: Make of_device_id array const
From: Linus Walleij <linus.walleij@linaro.org>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 5:39 PM, Kiran Padwal
<kiran.padwal@smartplayin.com> wrote:

> Make of_device_id array const, because all OF functions handle it as const.
> ---
>  drivers/pinctrl/pinctrl-imx50.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

APplied and squashed.

Yours,
Linus Walleij
