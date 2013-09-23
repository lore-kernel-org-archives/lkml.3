Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab3IWIpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:45:35 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:59022 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab3IWIpc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:45:32 -0400
MIME-Version: 1.0
In-Reply-To: <1379364632-19197-1-git-send-email-vincent.stehle@laposte.net>
References: <1379364632-19197-1-git-send-email-vincent.stehle@laposte.net>
Date: Mon, 23 Sep 2013 10:45:32 +0200
Message-ID: <CACRpkdZBNjGZbbU0FznQYMc1nfqt9YWESmRSNJqJzAnyLL17Hg@mail.gmail.com>
Subject: Re: [PATCH linux-next] pinctrl: fix pinconf_dbg_config_write return type
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Vincent_Stehl=E9?= <vincent.stehle@laposte.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 10:50 PM, Vincent Stehlé
<vincent.stehle@laposte.net> wrote:

> Have pinconf_dbg_config_write() return a ssize_t. This fixes the following
> compilation warning:
>
>   drivers/pinctrl/pinconf.c:617:2: warning: initialization from incompatible pointer type [enabled by default]
>   drivers/pinctrl/pinconf.c:617:2: warning: (near initialization for ‘pinconf_dbg_pinconfig_fops.write’) [enabled by default]
>
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> Cc: Linus Walleij <linus.walleij@linaro.org>

Patch applied!

Yours,
Linus Walleij
