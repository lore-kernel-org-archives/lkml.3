Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbaHGX2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 19:28:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36335 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaHGX2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 19:28:06 -0400
Message-ID: <53E40B8E.3080100@wwwdotorg.org>
Date: Thu, 07 Aug 2014 17:28:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 2/3] soc/tegra: Use of_match_machine in soc_is_tegra()
References: <1407452515-2390-1-git-send-email-ttynkkynen@nvidia.com> <1407452515-2390-3-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1407452515-2390-3-git-send-email-ttynkkynen@nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 05:01 PM, Tuomas Tynkkynen wrote:
> Use the new helper function, also fixing a device_node refcount leak.

Acked-by: Stephen Warren <swarren@nvidia.com>

I assume this will go through some common branch in arm-soc so others 
can build on it?
