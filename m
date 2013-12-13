Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab3LMT5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 14:57:30 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41589 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab3LMT52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 14:57:28 -0500
Message-ID: <52AB66A4.9080209@wwwdotorg.org>
Date: Fri, 13 Dec 2013 12:57:24 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Tomasz Figa <t.figa@samsung.com>, Olof Johansson <olof@lixom.net>,
        Dave Martin <Dave.Martin@arm.com>, Kevin Hilman <khilman@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gnurou@gmail.com
Subject: Re: [PATCH v11 0/7] ARM: support for the Trusted Foundations secure
 monitor
References: <1385274652-16415-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1385274652-16415-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2013 11:30 PM, Alexandre Courbot wrote:
> New rebase that should be ready-to-apply on the latest Tegra tree. The last
> remaining blocker is Russell's approval for this series and it is my hope to
> obtain it with this version.
> 
> There has been quite some debate around this series, notably about the SMC
> calling conventions and whether the firmware interface should be moved out of
> arch/arm. I hope that all the questions have been answered and that we can move
> forward with this series that enables NVIDIA-branded retail Tegra devices to run
> mainline.

I have applied this series to Tegra's for-3.14/trusted-foundations
branch. This is based directly on v3.13-rc1, so that if anyone needs to
merge patch 1 anywhere else to resolve conflicts, it'll be easy. I can
create a signed tag for that purpose if required.
