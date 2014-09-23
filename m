Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbaIWPCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:02:40 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36477 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669AbaIWPCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:02:36 -0400
MIME-Version: 1.0
In-Reply-To: <1410340551-24023-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1410340551-24023-1-git-send-email-antoine.tenart@free-electrons.com>
Date: Tue, 23 Sep 2014 17:02:35 +0200
Message-ID: <CACRpkdbtoOmBE4thmegDDR1Ev+9+Neq5j8z2Nr5MDi_P7yA2hQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: berlin: fix the dt_free_map function
From: Linus Walleij <linus.walleij@linaro.org>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zhiming Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 11:15 AM, Antoine Tenart
<antoine.tenart@free-electrons.com> wrote:

> The berlin_pinctrl_dt_free_map function tries to free memory
> allocated and handled by the of subsystem. This is wrong and
> already handled by pinctrl_dt_free_maps() which calls
> of_node_put().
>
> This patch fixes the Berlin pinctrl way of freeing its maps,
> avoiding a kernel BUG(), by using the common
> pinctrl_utils_dt_free_map function instead.
>
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Patch applied with Sebastian's ACK.

Yours,
Linus Walleij
