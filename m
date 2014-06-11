Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbaFKMw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:52:56 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:37212 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbaFKMwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:52:55 -0400
MIME-Version: 1.0
In-Reply-To: <1401700213-11917-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1401699818-11329-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1401700213-11917-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Wed, 11 Jun 2014 14:52:54 +0200
Message-ID: <CACRpkdYwe7Tge2HsK=pDiG3s1HwJFmYvT0DXo6btMzxmBW+3gw@mail.gmail.com>
Subject: Re: [PATCH v6 12/12] mmc: mmci: Add Qualcomm Id to amba id table
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 11:10 AM,  <srinivas.kandagatla@linaro.org> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> This patch adds a fake Qualcomm ID 0x00051180 to the amba_ids, as Qualcomm
> SDCC controller is pl180, but amba id registers read 0x0's.
> The plan is to remove SDCC driver totally and use mmci as the main SD
> controller driver for Qualcomm SOCs.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
