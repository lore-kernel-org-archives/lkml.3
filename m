Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab3GOQs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:48:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58680 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab3GOQsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:48:25 -0400
Message-ID: <51E427D6.7090702@wwwdotorg.org>
Date: Mon, 15 Jul 2013 10:48:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] ARM: tegra: enable palmas device for dalmore
References: <1373441852-27176-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1373441852-27176-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 01:37 AM, Laxman Dewangan wrote:
> Make the entry of Dalmore Power Management Unit device TPS65913
> in dalmore DTS file. The Palma driver support this device.
> 
> Enable following submodule of the TPS65913:
> - GPIO driver
> - RTC driver.
> - Power regulator driver.

If I apply this, (at least) the SD card no longer works. I assume the
regulator for it is being turned off somehow.
