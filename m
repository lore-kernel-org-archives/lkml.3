Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaH2FI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 01:08:26 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:50957 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaH2FIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 01:08:25 -0400
MIME-Version: 1.0
In-Reply-To: <1407771746-19819-1-git-send-email-kiran.padwal@smartplayin.com>
References: <1407771746-19819-1-git-send-email-kiran.padwal@smartplayin.com>
Date: Fri, 29 Aug 2014 07:08:24 +0200
Message-ID: <CACRpkdY5H_edOXmejue2Vm0h4vZe46yJs-xMeZuYSfNJr8ao8w@mail.gmail.com>
Subject: Re: [PATCH 10/11] pinctrl: imx6q: Make of_device_id array const
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
>  drivers/pinctrl/pinctrl-imx6q.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied and squashed.

Yours,
Linus Walleij
