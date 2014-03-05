Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaCEGTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 01:19:44 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:57638 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaCEGTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 01:19:43 -0500
Date: Tue, 4 Mar 2014 22:19:37 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Christian Riesch <christian.riesch@omicron.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>
Subject: Re: [PATCH v2 RESEND 1/2] mtd: Add a retlen parameter to
 _get_{fact,user}_prot_info
Message-ID: <20140305061937.GK13420@norris-Latitude-E6410>
References: <1390897785-991-1-git-send-email-christian.riesch@omicron.at>
 <db5db0eb-2c50-4642-ab11-5c406356bdeb@mary.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db5db0eb-2c50-4642-ab11-5c406356bdeb@mary.at.omicron.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 09:29:44AM +0100, Christian Riesch wrote:
> Signed-off-by: Christian Riesch <christian.riesch@omicron.at>
> Cc: Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>
> Cc: Brian Norris <computersforpeace@gmail.com>
> ---
>  drivers/mtd/chips/cfi_cmdset_0001.c |   31 +++++++++++++------------------
>  drivers/mtd/devices/mtd_dataflash.c |    7 ++++---
>  drivers/mtd/mtdchar.c               |   11 ++++++-----
>  drivers/mtd/mtdcore.c               |   12 ++++++------
>  drivers/mtd/mtdpart.c               |   14 ++++++++------
>  drivers/mtd/onenand/onenand_base.c  |   30 ++++++++++++------------------
>  include/linux/mtd/mtd.h             |   16 ++++++++--------
>  7 files changed, 57 insertions(+), 64 deletions(-)

Pushed patch 1 to l2-mtd.git. I may not push patch 2 yet; let me know if
you see a problem with that.

Thanks,
Brian
