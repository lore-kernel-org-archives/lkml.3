Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab3COTcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:32:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54680 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab3COTcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:32:52 -0400
Message-ID: <51437761.6020901@wwwdotorg.org>
Date: Fri, 15 Mar 2013 13:32:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: wsa@the-dreams.de, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: tegra: check the clk_prepare_enable() return value
References: <1363361648-10326-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1363361648-10326-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 09:34 AM, Laxman Dewangan wrote:
> NVIDIA's Tegra SoC allows read/write of controller register only
> if controller clock is enabled. System hangs if read/write happens
> to registers without enabling clock.
> 
> clk_prepare_enable() can be fail due to unknown reason and hence
> adding check for return value of this function. If this function
> success then only access register otherwise return to caller with
> error.

Wolfram,

Reviewed-by: Stephen Warren <swarren@nvidia.com>

This is probably suitable for Cc: stable.
