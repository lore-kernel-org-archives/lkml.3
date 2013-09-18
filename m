Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab3IRQRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 12:17:37 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:4745 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab3IRQRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 12:17:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Sep 2013 09:17:34 -0700
Message-ID: <5239D71E.3040005@nvidia.com>
Date: Wed, 18 Sep 2013 22:08:54 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH REPOST] ARM: tegra: use dt-binding header for key code
References: <1379510552-23401-1-git-send-email-ldewangan@nvidia.com> <5239C6AC.10403@nvidia.com>
In-Reply-To: <5239C6AC.10403@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 September 2013 08:58 PM, Stephen Warren wrote:
> On 09/18/2013 07:22 AM, Laxman Dewangan wrote:
>> In place of hardcoding the key code in DTS file and comment the
>> key code as side notes, use the key code macro defines in the
>> dt-bindings/input/input.h directly.
> I can apply this, but aren't there many other Tegra DT files that need
> conversion too?
Yes, I am planning to this in next few days. I will post different 
patches for different boards.
If it is fine to you, it can be applied this patch.
