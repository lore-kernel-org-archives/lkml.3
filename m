Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab3CLFB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:01:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46177 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab3CLFBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:01:23 -0400
Message-ID: <513EB704.8030907@ti.com>
Date: Tue, 12 Mar 2013 10:33:00 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: cpufreq <cpufreq@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Shawn Guo <shawn.guo@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/2] cpufreq: cpufreq-cpu0: support for clock which are
 not in DT yet.
References: <1363043130-30270-1-git-send-email-nm@ti.com> <1363043130-30270-2-git-send-email-nm@ti.com>
In-Reply-To: <1363043130-30270-2-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 March 2013 04:35 AM, Nishanth Menon wrote:
> On certain SoCs like variants of OMAP, the clock conversion to DT
> is not complete. In short, the ability to:
> cpus {
>     cpu@0 {
> 	clocks = <&cpuclk 0>;
>     };
>  };
> is not possible. However, the clock node is registered.
> Allow for clk names to be provided as string so as to be used when needed.
> Example (for OMAP3630):
> cpus {
>     cpu@0 {
> 	clock-name = "cpufreq_ck";
>     };
>  };
> 
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: cpufreq@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-omap@vger.kernel.org
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
Seems a reasonable to me.
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>


