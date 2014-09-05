Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaIEQ4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:56:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49225 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaIEQ4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:56:03 -0400
Message-ID: <5409EB27.4000905@wwwdotorg.org>
Date: Fri, 05 Sep 2014 10:56:07 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mikko Perttunen <cyndis@kapsi.fi>
CC: wsa@the-dreams.de, ldewangan@nvidia.com, thierry.reding@gmail.com,
        linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mikko Perttunen <mperttunen@nvidia.com>
Subject: Re: [PATCH v2] i2c: i2c-tegra: Move clk_prepare/clk_set_rate to probe
References: <1409909298-11361-1-git-send-email-cyndis@kapsi.fi>
In-Reply-To: <1409909298-11361-1-git-send-email-cyndis@kapsi.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 03:28 AM, Mikko Perttunen wrote:
> From: Mikko Perttunen <mperttunen@nvidia.com>
>
> Currently the i2c-tegra bus driver prepares, enables
> and set_rates its clocks separately for each transfer.
> This causes locking problems when doing I2C transfers
> from clock notifiers; see
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/268653.html
>
> This patch moves clk_prepare/unprepare and clk_set_rate calls to
> the probe function, leaving only clk_enable/disable to be
> done on each transfer. This solves the locking issue.

Reviewed-by: Stephen Warren <swarren@nvidia.com>
