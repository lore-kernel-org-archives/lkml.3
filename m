Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab3FQSYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:24:54 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:39827 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab3FQSYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:24:51 -0400
Date: Mon, 17 Jun 2013 11:24:46 -0700
From: Tejun Heo <tj@kernel.org>
To: Girish K S <girishks2000@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH V2] ahci: sata: add support for exynos5440 sata
Message-ID: <20130617182446.GI32663@mtj.dyndns.org>
References: <1366104482-14240-1-git-send-email-ks.giri@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366104482-14240-1-git-send-email-ks.giri@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 02:58:02PM +0530, Girish K S wrote:
> This patch adds the compatible string of the exynos5440 sata controller
> compliant with the ahci 1.3 and sata 3.0 specification.
> 
> Signed-off-by: Girish K S <ks.giri@samsung.com>
> 
> changes in v2:
> 		changed the compatible string by adding the actual IP
> owners name instead of the SoC vendor name.

Applied to libata/for-3.11.

Can you please keep SOB at the end of the description after the
revision history from the next time?

Thanks.

-- 
tejun
