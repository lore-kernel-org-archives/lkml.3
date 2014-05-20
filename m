Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaETIsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:48:16 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:44087 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaETIsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:48:13 -0400
Date: Tue, 20 May 2014 09:48:05 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Doug Anderson <dianders@chromium.org>, swarren@nvidia.com,
        wsa@the-dreams.de, abrestic@chromium.org, dgreid@chromium.org,
        olof@lixom.net, sjg@chromium.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, thierry.reding@gmail.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/7] ARM: tegra: Add the EC i2c tunnel to
 tegra124-venice2
Message-ID: <20140520084805.GH24991@lee--X1>
References: <1398879850-9111-1-git-send-email-dianders@chromium.org>
 <1398879850-9111-8-git-send-email-dianders@chromium.org>
 <53629B29.3050702@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53629B29.3050702@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This adds the EC i2c tunnel (and devices under it) to the
> > tegra124-venice2 device tree.
> 
> I'll happily take this into the Tegra tree once the patch containing the
> binding it uses is applied.

All other patches applied.  Take this when ready.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
