Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbbANL75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 06:59:57 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:44971 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbbANL7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 06:59:55 -0500
MIME-Version: 1.0
In-Reply-To: <1420448590-9503-1-git-send-email-k.kozlowski@samsung.com>
References: <1420448590-9503-1-git-send-email-k.kozlowski@samsung.com>
Date: Wed, 14 Jan 2015 12:59:54 +0100
Message-ID: <CACRpkdbe_=M51nGSHxV9BFrxwx7j-V62NSpf2REuXAf1zLycFw@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: dove: Constify struct regmap_config and of_device_id
From: Linus Walleij <linus.walleij@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 10:03 AM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:

> The regmap_config struct may be const because it is not modified by the
> driver and regmap_init() accepts pointer to const. Make also
> of_device_id array const.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Patch applied.

Yours,
Linus Walleij
