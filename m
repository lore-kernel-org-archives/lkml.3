Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbaDOSbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:31:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47211 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaDOSb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:31:29 -0400
Message-ID: <534D7AFD.7080807@wwwdotorg.org>
Date: Tue, 15 Apr 2014 12:31:25 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
CC: linux-mmc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: tegra: fix Venice2 VQMMC regulators
References: <1397526163-20126-1-git-send-email-abrestic@chromium.org> <1397526163-20126-5-git-send-email-abrestic@chromium.org>
In-Reply-To: <1397526163-20126-5-git-send-email-abrestic@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 07:42 PM, Andrew Bresticker wrote:
> VDDIO_SDMMC3 is the VQMMC supply, not the VMMC supply, for the SD
> slot.  Add 1.8V_VDDIO as the VQMMC supply for the eMMC.

Is there documentation re: what vmmc-supply and vqmmc-supply actually
refer to? I looked a long while ago and couldn't find any, and didn't
get an answer when I asked.

Neither
Documentation/devicetree/bindings/mmc/{mmc.txt,nvidia,tegra20-sdhci.txt}
seem to say:-(
