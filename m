Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763259Ab3DCTrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:47:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33040 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab3DCTrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:47:10 -0400
Message-ID: <515C873A.2060504@wwwdotorg.org>
Date: Wed, 03 Apr 2013 13:47:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, stern@rowland.harvard.edu, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 0/7] USB: PHY: Tegra: registering TEGRA USB PHY as platform
 driver
References: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com> <5148C1DC.1020903@wwwdotorg.org>
In-Reply-To: <5148C1DC.1020903@wwwdotorg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 01:51 PM, Stephen Warren wrote:
> On 03/18/2013 06:29 AM, Venu Byravarasu wrote:
>> As part of this series, apart from patch containing changes to register TEGRA
>> USB PHY driver as platform driver, prepared below patches:
>> 1. Re-arranging & adding new DT properties.
>> 2. Getting various params from DT properties added.
>> 3. code clean up.
> 
> Venu, I'm curious whether these patches were tested at all. I have found
> at least two significant problems with trivial testing:
...
> "reboot" or "shutdown -h now" both cause the following crash
...
> The first time enumeration USB devices is attempted on a port fails.

For the record, V2 of this series fixes both of these problems.
