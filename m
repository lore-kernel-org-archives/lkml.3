Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab3CKRQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:16:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60753 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab3CKRQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:16:53 -0400
Date: Mon, 11 Mar 2013 17:10:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Danny Huang <dahuang@nvidia.com>
Cc: swarren@wwwdotorg.org, ldewangan@nvidia.com, pgaikwad@nvidia.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: tegra: fuse: export chip id and revision
Message-ID: <20130311171029.GO4977@n2100.arm.linux.org.uk>
References: <1363005441-26329-1-git-send-email-dahuang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363005441-26329-1-git-send-email-dahuang@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 08:37:21PM +0800, Danny Huang wrote:
> Expose tegra chip id and revision in /proc/cpu/chipinfo for user mode
> usage.

I thought we weren't exporting this stuff out via procfs, but had a
soc specific way to do it - drivers/base/soc.c ?  We have soc_id and
revision attributes there... it seems to do what you want already.
