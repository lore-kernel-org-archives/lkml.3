Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaBXNea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:34:30 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58345 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaBXNe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:34:28 -0500
MIME-Version: 1.0
In-Reply-To: <1392373266-28806-1-git-send-email-sonic.adi@gmail.com>
References: <1392373266-28806-1-git-send-email-sonic.adi@gmail.com>
Date: Mon, 24 Feb 2014 14:34:25 +0100
Message-ID: <CACRpkdYPYOpDw6DbQNyTLDTniYmvL5tV7ZGh66fjp7fCPWpOdw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-adi: combine multiple groups of one
 function together
From: Linus Walleij <linus.walleij@linaro.org>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Steven Miao <realmz6@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 11:21 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>
>
> The data pins of some peripheral are different if connecting to different
> devices in one pinmux function. In the PPI case, data pins can be used
> in 8, 16 and 24 pin groups individually. Add these groups into one ppi
> function.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

Patch applied.

Yours,
Linus Walleij
