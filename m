Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaHVTZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:25:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:32921 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaHVTZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:25:47 -0400
Message-ID: <53F79952.6060002@wwwdotorg.org>
Date: Fri, 22 Aug 2014 13:26:10 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Marcel Ziswiler <marcel@ziswiler.com>, thierry.reding@gmail.com
CC: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch
Subject: Re: [PATCH] arm: tegra: apalis/colibri t30: fix on-module 5v0 supplies
References: <cbf0902cd98332bc0218d84fd055b42fab3ea3b2.1408719375.git.marcel@ziswiler.com>
In-Reply-To: <cbf0902cd98332bc0218d84fd055b42fab3ea3b2.1408719375.git.marcel@ziswiler.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 09:06 AM, Marcel Ziswiler wrote:
> Working on Gigabit/PCIe support in U-Boot for Apalis T30 I realised
> that the current device tree source includes for our modules only
> happen to work due to referencing the on-carrier 5v0 supply from USB
> which is not at all available on-module. The modules actually contain
> TPS60150 charge pumps to generate the PMIC required 5 volts from the
> one and only 3.3 volt module supply. This patch fixes this.

I've forwarded this to the ARM SoC maintainers as a fix for v3.17.
