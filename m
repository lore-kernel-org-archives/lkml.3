Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaHPNNK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 09:13:10 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:45041 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaHPNNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 09:13:08 -0400
Date: Sat, 16 Aug 2014 09:13:04 -0400
From: Tejun Heo <tj@kernel.org>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: swarren@wwwdotorg.org, thierry.reding@gmail.com, linux-ide@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci_tegra: Change include to fix compilation
Message-ID: <20140816131304.GK9305@htj.dyndns.org>
References: <1407752268-18745-1-git-send-email-mperttunen@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407752268-18745-1-git-send-email-mperttunen@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 01:17:48PM +0300, Mikko Perttunen wrote:
> Before this patch, the driver included <linux/tegra-powergate.h>,
> which was effectively renamed to <soc/tegra/pmc.h> at about the same
> time the ahci_tegra series landed. Fix the include path so that the
> driver compiles.
> 
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>

Applied to libata/for-3.17-fixes.

Thanks.

-- 
tejun
