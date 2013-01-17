Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab3AQNNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:13:06 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:32777 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab3AQNNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:13:05 -0500
Message-ID: <50F7F8D4.90207@mvista.com>
Date: Thu, 17 Jan 2013 17:12:52 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Fabio Baltieri <fabio.baltieri@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
Subject: Re: [PATCH] usb: musb: ux500: use clk_prepare_enable and clk_disable_unprepare
References: <1357577261-31536-1-git-send-email-fabio.baltieri@linaro.org> <CACRpkdZD1i_tvDf6XFyk5muYjtDziQaMNGK6vvihhFJVztXUjw@mail.gmail.com> <20130110133818.GA22710@balto.lan> <CACRpkdbmgQ0xDfkbgqc=zDqMDUK0O6uQOf3kX9v1+=+N5s42bw@mail.gmail.com>
In-Reply-To: <CACRpkdbmgQ0xDfkbgqc=zDqMDUK0O6uQOf3kX9v1+=+N5s42bw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 17-01-2013 14:46, Linus Walleij wrote:

>>> <fabio.baltieri@linaro.org> wrote:

>>>> This patch converts the module to use clk_prepare_enable and
>>>> clk_disable_unprepare variants as required by common clock framework.

>>>> Without this the system crash during probe function.

>>>> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

>>> Acked-by: Linus Walleij <linus.walleij@linaro.org>

>> Thanks for the ACK.  This bug was here unnoticed since 3.6 merge window,

> Then it should have Cc: stable@kernel.org..

    The new address is stable@vger.kernel.org.

WBR, Sergei

