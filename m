Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbaGXJuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:50:24 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9196 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793AbaGXJuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:50:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 24 Jul 2014 02:42:23 -0700
Message-ID: <53D0D694.9040101@nvidia.com>
Date: Thu, 24 Jul 2014 15:19:08 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] thermal: of: look for sensor driver parent node if device
 node missing
References: <1405336354-31310-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1405336354-31310-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 July 2014 04:42 PM, Laxman Dewangan wrote:
> There are some mfd devices which supports junction thermal interrupt
> like ams,AS3722. The DT binding of these devices are defined as the
> flat and drivers for sub module of such devices are registered as
> the mfd_add_devices. In this method, the sub devices registered as
> platform driver and these do not have the of_node pointer on their
> device structure. In this case, use the parent of_node pointer to
> get the required of_node pointer.
>
Any comment please?
