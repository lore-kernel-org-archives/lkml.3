Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab3ENL5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:57:04 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:43219 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3ENL5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:57:02 -0400
MIME-Version: 1.0
In-Reply-To: <001f01ce4a0b$b21c5520$1654ff60$@samsung.com>
References: <001f01ce4a0b$b21c5520$1654ff60$@samsung.com>
Date: Tue, 14 May 2013 13:57:02 +0200
Message-ID: <CACRpkdaBOOmNdQNpOdn6dned2O1BpmnEGBh_5UiED+UQySbTYA@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: mxs: remove unnecessary platform_set_drvdata()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 5:42 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied with Shawn's ACK.

Thanks!
Linus Walleij
