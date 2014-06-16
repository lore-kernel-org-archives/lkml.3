Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbaFPTBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 15:01:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50939 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251AbaFPTBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 15:01:39 -0400
Message-ID: <539F3F0F.1060101@wwwdotorg.org>
Date: Mon, 16 Jun 2014 13:01:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, lee.jones@linaro.org,
        swarren@nvidia.com, wsa@the-dreams.de
CC: abrestic@chromium.org, dgreid@chromium.org, olof@lixom.net,
        sjg@chromium.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, thierry.reding@gmail.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/7] ARM: tegra: Add the EC i2c tunnel to tegra124-venice2
References: <1398879850-9111-1-git-send-email-dianders@chromium.org> <1398879850-9111-8-git-send-email-dianders@chromium.org>
In-Reply-To: <1398879850-9111-8-git-send-email-dianders@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 11:44 AM, Doug Anderson wrote:
> This adds the EC i2c tunnel (and devices under it) to the
> tegra124-venice2 device tree.

I've applied this to Tegra's for-3.17/dt branch.
