Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab3COTFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:05:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43457 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab3COTFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:05:18 -0400
Message-ID: <514370EB.1030706@wwwdotorg.org>
Date: Fri, 15 Mar 2013 13:05:15 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "arm@kernel.org" <arm@kernel.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: fix register address of slink controller
References: <1363373730-10703-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1363373730-10703-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 12:55 PM, Laxman Dewangan wrote:
> Fix typo on register address of slink3 controller where register
> address is wrongly set as 0x7000d480 but it is 0x7000d800.

Arnd, Olof,

Can you please apply this as a fix for v3.9-rc, and Cc: stable too? Let
me know if you need me to resend the patch to arm@kernel.org to enable this.

Reviewed-by: Stephen Warren <swarren@nvidia.com>

Thanks.
