Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab3G3Qk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 12:40:28 -0400
Received: from void.printf.net ([89.145.121.20]:54670 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab3G3QkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 12:40:25 -0400
From: Chris Ball <cjb@laptop.org>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: linux-mmc@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Asutosh Das <asutoshd@codeaurora.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Sahitya Tummala <stummala@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] mmc: sdhci-msm: Add support for MSM chipsets
References: <1375201355-26906-1-git-send-email-gdjakov@mm-sol.com>
Date: Tue, 30 Jul 2013 17:40:16 +0100
In-Reply-To: <1375201355-26906-1-git-send-email-gdjakov@mm-sol.com> (Georgi
	Djakov's message of "Tue, 30 Jul 2013 19:22:35 +0300")
Message-ID: <86y58orogf.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Georgi,

On Tue, Jul 30 2013, Georgi Djakov wrote:
> This platform driver adds the support of Secure Digital Host
> Controller Interface compliant controller in MSM chipsets.
>
> CC: Asutosh Das <asutoshd@codeaurora.org>
> CC: Venkat Gopalakrishnan <venkatg@codeaurora.org>
> CC: Sahitya Tummala <stummala@codeaurora.org>
> CC: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> ---
> This is an initial version of the Qualcomm MSM SDHCI driver.
> It is based on the SDHCI code from coreaurora.org with minor
> modifications. The MMC standard DT bindings are used where
> possible. The patch applies to v3.11-rc3.

Is the arch code that will use this driver already in mainline,
or on its way in?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
