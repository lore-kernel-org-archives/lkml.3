Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab3BEVYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:24:44 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:60428 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab3BEVYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:24:39 -0500
Date: Tue, 5 Feb 2013 13:24:37 -0800
From: Olof Johansson <olof@lixom.net>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-tegra@vger.kernel.org, Sami Liedes <sliedes@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: tegra: Fix build error for gic update
Message-ID: <20130205212437.GA23108@quad.lixom.net>
References: <1359976100-28871-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359976100-28871-1-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 01:08:18PM +0200, Hiroshi Doyu wrote:
> Fix build error in board-dt-tegra114.c(next-20130204)
> 
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> Reported-by: Sami Liedes<sliedes@nvidia.com>

Applied to arm-soc next/soc, after t114 support.


-Olof
