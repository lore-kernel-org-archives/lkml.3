Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbaDOSRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:17:23 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:37026 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaDOSRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:17:17 -0400
Date: Tue, 15 Apr 2014 14:17:13 -0400
From: Tejun Heo <tj@kernel.org>
To: Peter Foley <pefoley2@pefoley.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] ata: fix kconfig selection warning
Message-ID: <20140415181713.GE30990@htj.dyndns.org>
References: <1397584255-15038-1-git-send-email-pefoley2@pefoley.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397584255-15038-1-git-send-email-pefoley2@pefoley.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 15, 2014 at 01:50:55PM -0400, Peter Foley wrote:
> When building with COMPILE_TEST, AHCI_XGENE is enabled even though
> PHY_XGENE (which it selects) requires OF to be enabled.
> Fix this by adding a dependency on OF to AHCI_XGENE.
> 
> warning: (AHCI_XGENE) selects PHY_XGENE which has unmet direct
> dependencies (HAS_IOMEM && OF && (ARM64 || COMPILE_TEST))
> 
> Signed-off-by: Peter Foley <pefoley2@pefoley.com>

Already fixed in libata/for-3.15-fixes.  Will push out in several
days.

Thanks.

-- 
tejun
