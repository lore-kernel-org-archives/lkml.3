Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab3GOQsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:48:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40311 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab3GOQsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:48:52 -0400
Message-ID: <51E427F1.9010106@wwwdotorg.org>
Date: Mon, 15 Jul 2013 10:48:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: khali@linux-fr.org, linux@roeck-us.net, thierry.reding@gmail.com,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 0/2] Enable lm90 in Tegra30 and Tegra114.
References: <1373615364-18559-1-git-send-email-wni@nvidia.com>
In-Reply-To: <1373615364-18559-1-git-send-email-wni@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 01:49 AM, Wei Ni wrote:
> Enable thermal sensor lm90 for Tegra30 Cardhu and Tegra114 Dalmore.

I have applied the series to Tegra's for-3.12/dt branch.
