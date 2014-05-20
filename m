Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaETShZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 14:37:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57107 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaETShX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 14:37:23 -0400
Message-ID: <537BA0DF.60003@wwwdotorg.org>
Date: Tue, 20 May 2014 12:37:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 3/3] clocksource: tegra: Use uS counter as delay timer
References: <1400600176-435-1-git-send-email-pdeschrijver@nvidia.com> <1400600176-435-4-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1400600176-435-4-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 09:36 AM, Peter De Schrijver wrote:
> All Tegra SoCs have a freerunning microsecond counter which can be used as a
> delay timer.

Patch 3 looks fine to me. I'll be happy to apply it once the other
patches are applied (or ack it or create a topic branch containing all 3
if needed, so it can be applied without waiting for dependencies to
filter up to Linus).
