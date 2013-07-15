Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121Ab3GOPjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:39:45 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:58185 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932646Ab3GOPjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:39:44 -0400
MIME-Version: 1.0
In-Reply-To: <1373898160-8460-1-git-send-email-otavio@ossystems.com.br>
References: <1373898160-8460-1-git-send-email-otavio@ossystems.com.br>
Date: Mon, 15 Jul 2013 12:39:43 -0300
Message-ID: <CAOMZO5C_7nJ9RVYvuKJHP2u0mYY6P2UyGVA6OpPzqTnd7YXN2Q@mail.gmail.com>
Subject: Re: [PATCH 1/5] ARM: dts: imx23-evk: enable USB PHY and controller
From: Fabio Estevam <festevam@gmail.com>
To: Otavio Salvador <otavio@ossystems.com.br>
Cc: Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Otavio,

On Mon, Jul 15, 2013 at 11:22 AM, Otavio Salvador
<otavio@ossystems.com.br> wrote:
> The i.MX23EVK board provides a USB port so the USB PHY and controller
> need to be enabled for it to be usable.
>
> Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
> ---

You should have Cc'd Shawn Guo on this series.
