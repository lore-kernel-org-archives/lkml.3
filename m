Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbaFXTVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:21:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39287 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbaFXTVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:21:30 -0400
Message-ID: <53A9CFB3.6080501@wwwdotorg.org>
Date: Tue, 24 Jun 2014 13:21:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5/6] include/linux/platform_data/tegra_emc.h: Remove unused
 header
References: <1403630855-29186-1-git-send-email-linux@rasmusvillemoes.dk> <1403630855-29186-6-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1403630855-29186-6-git-send-email-linux@rasmusvillemoes.dk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 11:27 AM, Rasmus Villemoes wrote:
> The header file include/linux/platform_data/tegra_emc.h does not seem
> to be used anywhere. It was orphaned by a7cbe92c "ARM: tegra: remove
> tegra EMC scaling driver". Remove it.

Acked-by: Stephen Warren <swarren@nvidia.com>

Perhaps this should go through the arm-soc tree like the original
commit, but it doesn't really matter either way.
