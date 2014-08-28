Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbaH1Qx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 12:53:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59551 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaH1Qxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 12:53:55 -0400
Message-ID: <53FF5EA1.4050708@wwwdotorg.org>
Date: Thu, 28 Aug 2014 10:53:53 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
CC: Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/linux/platform_data/tegra_emc.h: Remove unused
 header
References: <1409226858-3406-1-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1409226858-3406-1-git-send-email-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2014 05:54 AM, Rasmus Villemoes wrote:
> The header file include/linux/platform_data/tegra_emc.h does not seem
> to be used anywhere. It was orphaned by a7cbe92c "ARM: tegra: remove
> tegra EMC scaling driver". Remove it.

Applied to Tegra's for-3.18/soc branch.

