Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbaEOSmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:42:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39179 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaEOSmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:42:40 -0400
Message-ID: <53750A9A.8000808@wwwdotorg.org>
Date: Thu, 15 May 2014 12:42:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>
CC: Stephen Warren <swarren@nvidia.com>, abrestic@chromium.org,
        dgreid@chromium.org, Olof Johansson <olof@lixom.net>,
        Simon Glass <sjg@chromium.org>, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] ARM: tegra: Add the EC i2c tunnel to tegra124-venice2
References: <1397757570-19750-1-git-send-email-dianders@chromium.org> <1397757570-19750-8-git-send-email-dianders@chromium.org>
In-Reply-To: <1397757570-19750-8-git-send-email-dianders@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 11:59 AM, Doug Anderson wrote:
> This adds the EC i2c tunnel (and devices under it) to the
> tegra124-venice2 device tree.

Did the MFD patches at the start of this series get applied yet? I was
hoping to apply this one patch to the Tegra tree for 3.16, and that
needs to happen by tomorrow morning at the latest since -rc6 is looming
fast. However, I'm holding off until the rest of the series is applied
to the MFD tree so I can be sure the DT binding is accepted first...
