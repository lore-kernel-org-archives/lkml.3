Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab3ARQom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 11:44:42 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55026 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab3ARQol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 11:44:41 -0500
Message-ID: <50F97BF6.6020705@wwwdotorg.org>
Date: Fri, 18 Jan 2013 09:44:38 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: DTS: whistler: enable keyboard
References: <1358488723-23184-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1358488723-23184-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 10:58 PM, Laxman Dewangan wrote:
> Enable tegra based keyboard controller and populate the key mapping
> for whistler.
> 
> With this patch, HOME, BACK, POWER and MENU keys will work.
> Still other keys which are in ROW3 and ROW4 will not work as it
> conflicts with KBC pins on SDIO2 pinmux.

Thanks, applied to Tegra's for-3.9/dt branch.
