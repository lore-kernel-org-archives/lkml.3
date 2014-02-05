Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbaBESpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 13:45:33 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37225 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbaBESp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 13:45:29 -0500
Message-ID: <52F286C6.1030903@wwwdotorg.org>
Date: Wed, 05 Feb 2014 11:45:26 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Olof Johansson <olof@lixom.net>, Danny Huang <dahuang@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Joseph Lo <josephl@nvidia.com>
Subject: Re: [PATCH v3 6/6] ARM: tegra: remove fuse files from mach-tegra
References: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com> <1390952176-30402-7-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1390952176-30402-7-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 04:36 PM, Peter De Schrijver wrote:
> All fuse related functionality is now provided by the tegra fuse driver.
> Hence all the fuse related files in mach-tegra can be removed.

It's probably worth squashing this into patch 5, since that's what makes
these files unused.
