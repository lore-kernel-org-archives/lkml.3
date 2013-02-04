Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab3BDRBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 12:01:21 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37996 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab3BDRBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 12:01:18 -0500
Message-ID: <510FE95B.20207@wwwdotorg.org>
Date: Mon, 04 Feb 2013 10:01:15 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-tegra@vger.kernel.org, Sami Liedes <sliedes@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: tegra: Fix build error for gic update
References: <1359976100-28871-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1359976100-28871-1-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 04:08 AM, Hiroshi Doyu wrote:
> Fix build error in board-dt-tegra114.c(next-20130204)

Hiroshi, which tree should this patch be applied to? I assume it needs
to go through arm-soc since that's where the Tegra and GIC patches meet?
