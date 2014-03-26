Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbaCZOVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:21:36 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:61190 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaCZOVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:21:34 -0400
Date: Wed, 26 Mar 2014 10:21:29 -0400
From: Tejun Heo <tj@kernel.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-ide@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: fix R-Car SATA driver dependencies
Message-ID: <20140326142129.GD7171@htj.dyndns.org>
References: <4494466.bbG3GqUbue@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4494466.bbG3GqUbue@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 03:19:23PM +0100, Bartlomiej Zolnierkiewicz wrote:
> Make sata_rcar host driver depend on ARCH_SHMOBILE config option as
> Renesas R-Car SATA support is specific to Renesas SoCs and the driver
> to work requires suitable device tree node (or platform device) to be
> defined.  Additionally allow the driver build if COMPILE_TEST config
> option is set.
> 
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Applied to libata/for-3.15.

Thanks.

-- 
tejun
