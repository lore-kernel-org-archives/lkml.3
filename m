Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab3CFUik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 15:38:40 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33952 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3CFUij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 15:38:39 -0500
Message-ID: <5137A94A.2030203@wwwdotorg.org>
Date: Wed, 06 Mar 2013 13:38:34 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: tegra: move to of_clk_get
References: <1359985230-11506-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1359985230-11506-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 06:40 AM, Peter De Schrijver wrote:
> The new clockframework introduced DT IDs for each clock. To be able to remove
> the device registrations, this driver needs to be updated to use the DT IDs.
> Note that the actual removal of the clk_register_clkdev() calls will be done
> in a later series.

I've applied this to Tegra's for-3.10/cleanup branch.

