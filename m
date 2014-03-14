Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbaCNSbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 14:31:05 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:56382 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbaCNSbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 14:31:02 -0400
Date: Fri, 14 Mar 2014 14:30:57 -0400
From: Tejun Heo <tj@kernel.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci_platform: fix devm_ioremap_resource() return
 value checking
Message-ID: <20140314183057.GA6889@mtj.dyndns.org>
References: <2139783.QvectlX5nq@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2139783.QvectlX5nq@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 06:22:09PM +0100, Bartlomiej Zolnierkiewicz wrote:
> devm_ioremap_resource() returns a pointer to the remapped memory or
> an ERR_PTR() encoded error code on failure.  Fix the check inside
> ahci_platform_get_resources() accordingly.
> 
> Also while at it remove a needless line break.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Applied to libata/for-3.15.

Thanks.

-- 
tejun
