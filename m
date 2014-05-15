Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbaEOTWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:22:08 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55392 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaEOTWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:22:05 -0400
Message-ID: <537513D8.7060203@wwwdotorg.org>
Date: Thu, 15 May 2014 13:22:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>
CC: linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Jim Lin <jilin@nvidia.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH 04/10] clk: tegra: Initialize xusb clocks
References: <1400113986-339-1-git-send-email-abrestic@chromium.org> <1400113986-339-5-git-send-email-abrestic@chromium.org>
In-Reply-To: <1400113986-339-5-git-send-email-abrestic@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 06:33 PM, Andrew Bresticker wrote:
> Initialize the XUSB-related clocks with appropriate parents and rates
> for both Tegra114 and Tegra124.

These first 4 clock driver patches look plausible to me, although I
didn't look that hard!

Peter or Mike, if they look OK to you, can you please pick them up for
3.16 so that by the time we apply the rest of the patches in this series
for 3.17, the clock dependencies are already there? Thanks.
