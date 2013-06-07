Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab3FGHj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:39:59 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:35372 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3FGHj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:39:58 -0400
MIME-Version: 1.0
In-Reply-To: <201306061644.26078.heiko@sntech.de>
References: <201306061644.26078.heiko@sntech.de>
Date: Fri, 7 Jun 2013 09:39:57 +0200
Message-ID: <CACRpkdYXczRQKa_uAAZHdv7yDD+Od7RQb5NuZLV8=L0cDGJyUg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: add pinconf-generic define for a pin-default pull
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 4:44 PM, Heiko Stübner <heiko@sntech.de> wrote:

> There exist controllers that don't support to set the pull to up or down
> separately but instead automatically set the pull direction based on
> embedded knowledge inside the controller, for example depending on the
> selected mux function of the pin.
>
> Therefore this patch adds another config option to use this default
> pull-state for a pin where it is not possible to know or decide if the
> pin will be pulled up or down.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Excellent, patch applied with Stephen's ACK.

Yours,
Linus Walleij
