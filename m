Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab3JVSDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 14:03:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:33620 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab3JVSDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 14:03:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="423040589"
Message-ID: <5266BDC7.2050701@linux.intel.com>
Date: Tue, 22 Oct 2013 11:02:47 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the usb tree
References: <1382454517-4074-1-git-send-email-treding@nvidia.com> <1382454517-4074-4-git-send-email-treding@nvidia.com>
In-Reply-To: <1382454517-4074-4-git-send-email-treding@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 08:08 AM, Thierry Reding wrote:
> Today's linux-next merge of the usb tree got a conflict in
>
> 	drivers/Kconfig
>
> caused by commits ff76496 (drivers: phy: add generic PHY framework) and
> 12cc4b38 (PowerCap: Add to drivers Kconfig and Makefile).
>
> I fixed it up (see below). Please verify that the resolution look good.
>
> Thanks,
> Thierry
> ---
> diff --cc drivers/Kconfig
> index 969e987,8f45144..97536a2
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@@ -166,6 -166,6 +166,8 @@@ source "drivers/reset/Kconfig
>    
>    source "drivers/fmc/Kconfig"
>    
>   +source "drivers/powercap/Kconfig"
>   +
Look OK.
> + source "drivers/phy/Kconfig"
> +
>    endmenu

Thanks,
Srinivas

