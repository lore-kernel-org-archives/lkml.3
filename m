Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbaH2FPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 01:15:52 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:62869 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaH2FPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 01:15:51 -0400
MIME-Version: 1.0
In-Reply-To: <1407768897-12086-1-git-send-email-kiran.padwal@smartplayin.com>
References: <1407768897-12086-1-git-send-email-kiran.padwal@smartplayin.com>
Date: Fri, 29 Aug 2014 07:15:50 +0200
Message-ID: <CACRpkdZRsTwGKWeOZ=TB_=oHdUixc4qJKD77joDRJJw_KwwFRg@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: imx6sl: introduce MODULE_DEVICE_TABLE for
 module autoloading
From: Linus Walleij <linus.walleij@linaro.org>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 4:54 PM, Kiran Padwal
<kiran.padwal@smartplayin.com> wrote:

> Enable autoloading of pinctrl-imx6sl module when a corresponing DT entry is present.
>
> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>

This patch applied separately.

Yours,
Linus Walleij
