Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031784AbaGDXBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 19:01:34 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:64433 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030360AbaGDXBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 19:01:31 -0400
MIME-Version: 1.0
In-Reply-To: <1402398708-10722-1-git-send-email-thierry.reding@gmail.com>
References: <1402398708-10722-1-git-send-email-thierry.reding@gmail.com>
Date: Sat, 5 Jul 2014 01:01:30 +0200
Message-ID: <CACRpkdaLG+f41ot0H7sRm0zq+5=HROBKpKeXJC2+JYkq6a4Yog@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] of: Add NVIDIA Tegra XUSB pad controller binding
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 1:11 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:

> From: Thierry Reding <treding@nvidia.com>
>
> This patch adds the device tree binding documentation for the XUSB pad
> controller found on NVIDIA Tegra SoCs. It exposes both pinmuxing and PHY
> capabilities.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Changes in v2:
> - move header file to this patch and refer to it in the binding
> - update example to match the latest binding

Stephen/Laxman: any comments on this patch?

Yours,
Linus Walleij
