Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaH2FAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 01:00:24 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:48425 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaH2FAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 01:00:23 -0400
MIME-Version: 1.0
In-Reply-To: <1407771277-19477-2-git-send-email-kiran.padwal@smartplayin.com>
References: <1407771277-19477-1-git-send-email-kiran.padwal@smartplayin.com>
	<1407771277-19477-2-git-send-email-kiran.padwal@smartplayin.com>
Date: Fri, 29 Aug 2014 07:00:22 +0200
Message-ID: <CACRpkdYSDuvOUjb2o+EYOCQrG04uX-dUukStwmM+9Q7M0J=bXw@mail.gmail.com>
Subject: Re: [PATCH 01/11] pinctrl: imx23: Make of_device_id array const
From: Linus Walleij <linus.walleij@linaro.org>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 5:34 PM, Kiran Padwal
<kiran.padwal@smartplayin.com> wrote:

> Make of_device_id array const, because all OF functions handle it as const.
> ---
>  drivers/pinctrl/pinctrl-imx23.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied and squashed.

Yours,
Linus Walleij
