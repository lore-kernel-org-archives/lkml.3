Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbaEWMyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:54:41 -0400
Received: from void.printf.net ([89.145.121.20]:36410 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbaEWMwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:52:47 -0400
From: Chris Ball <chris@printf.net>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-tegra\@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/2] mmc: tegra: disable UHS modes
References: <1400774136-12396-1-git-send-email-abrestic@chromium.org>
	<CAPDyKFpt98rbFpvu1uzbOuhCTrO96hzQU2VwNRgJGfoi_7F-OA@mail.gmail.com>
Date: Fri, 23 May 2014 13:52:42 +0100
In-Reply-To: <CAPDyKFpt98rbFpvu1uzbOuhCTrO96hzQU2VwNRgJGfoi_7F-OA@mail.gmail.com>
	(Ulf Hansson's message of "Fri, 23 May 2014 09:03:33 +0200")
Message-ID: <86fvk0r71h.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, May 23 2014, Ulf Hansson wrote:
> On 22 May 2014 17:55, Andrew Bresticker <abrestic@chromium.org> wrote:
>> Program TEGRA_SDHCI_VENDOR_MISC_CTRL so that UHS modes aren't advertised
>> in SDHCI_CAPABILITIES_1.  While the Tegra SDHCI controller does support
>> these modes, they require Tegra-specific tuning and calibration routines
>> which the driver does not support yet.
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> Tested-by: Stephen Warren <swarren@nvidia.com>
>> Acked-by: Stephen Warren <swarren@nvidia.com>
>
> Thanks Andrew!
>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>
> Chris, can you pick this up?

Thanks, pushed to mmc-next for 3.16.

- Chris.
-- 
Chris Ball   <http://printf.net/>
