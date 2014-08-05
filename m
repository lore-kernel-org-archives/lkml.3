Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbaHEMYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:24:12 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14538 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbaHEMYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:24:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 05 Aug 2014 05:11:26 -0700
Message-ID: <53E0CCE2.4050008@nvidia.com>
Date: Tue, 5 Aug 2014 15:24:02 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "edubezval@gmail.com" <edubezval@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 4/4] thermal: Add Tegra SOCTHERM thermal management
 driver
References: <1407241137-32232-1-git-send-email-mperttunen@nvidia.com> <1407241137-32232-5-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1407241137-32232-5-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/14 15:18, Mikko Perttunen wrote:
> This adds support for the Tegra SOCTHERM thermal sensing and management
> system found in the Tegra124 system-on-chip. This initial driver supports
> the four thermal zones with hardware-tracked trip points.

.. does NOT support hardware-tracked trip points. I guess you always 
have to have at least one little mistake there.

Mikko

>
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> ---
> ...
