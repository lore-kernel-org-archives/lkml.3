Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784Ab3GSPdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:33:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43921 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab3GSPdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:33:12 -0400
Message-ID: <51E95C35.7060502@wwwdotorg.org>
Date: Fri, 19 Jul 2013 09:33:09 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: rklein@nvidia.com, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 RFT] ARM: tegra: enable palmas device for dalmore
References: <1374199992-27947-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1374199992-27947-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 08:13 PM, Laxman Dewangan wrote:
> Make the entry of Dalmore Power Management Unit device TPS65913
> in dalmore DTS file. The Palma driver support this device.
> 
> Enable following submodule of the TPS65913:
> - GPIO driver
> - RTC driver.
> - Power regulator driver.

OK, this version works fine. Applied to Tegra's for-3.12/dt branch.

> Changes from V2:
> - Made LDO9 as always ON for sd card functionality.

We really need to start hooking up the regulators to the SDHCI
controller nodes sometime soon... I let it slide here because it's at
least consistent with the regulators we already have in place on other
boards.
