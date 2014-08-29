Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaH2FJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 01:09:14 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:54304 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaH2FJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 01:09:12 -0400
MIME-Version: 1.0
In-Reply-To: <1407771761-19855-1-git-send-email-kiran.padwal@smartplayin.com>
References: <1407771761-19855-1-git-send-email-kiran.padwal@smartplayin.com>
Date: Fri, 29 Aug 2014 07:09:12 +0200
Message-ID: <CACRpkdYAuDnPoVFES4gNc10YDp4dZ02Nvdsk5k6=DT2kCW6=YQ@mail.gmail.com>
Subject: Re: [PATCH 11/11] pinctrl: imx6sx: Make of_device_id array const
From: Linus Walleij <linus.walleij@linaro.org>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 5:42 PM, Kiran Padwal
<kiran.padwal@smartplayin.com> wrote:

> Make of_device_id array const, because all OF functions handle it as const.
> ---
>  drivers/pinctrl/pinctrl-imx6sx.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied and squashed.

Yours,
Linus Walleij
