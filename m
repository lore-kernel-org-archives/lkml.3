Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab3GPDmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 23:42:17 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45892 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab3GPDmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 23:42:16 -0400
MIME-Version: 1.0
In-Reply-To: <1373898160-8460-1-git-send-email-otavio@ossystems.com.br>
References: <1373898160-8460-1-git-send-email-otavio@ossystems.com.br>
Date: Tue, 16 Jul 2013 00:42:15 -0300
Message-ID: <CAOMZO5D+szAgY6+CHjwFRw2qwvusv2_Ach0hv=hj4X1cmMnHfA@mail.gmail.com>
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

On Mon, Jul 15, 2013 at 11:22 AM, Otavio Salvador
<otavio@ossystems.com.br> wrote:
> The i.MX23EVK board provides a USB port so the USB PHY and controller
> need to be enabled for it to be usable.

Has this been tested? I don't see in this patch any code to enable USB power.
