Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbaCZPlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 11:41:16 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:42749 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaCZPlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 11:41:15 -0400
Date: Wed, 26 Mar 2014 11:41:11 -0400
From: Tejun Heo <tj@kernel.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>, Rob Herring <robh@kernel.org>,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: fix Calxeda Highbank SATA driver dependencies
Message-ID: <20140326154111.GF7171@htj.dyndns.org>
References: <2920312.TnoQcCR5HX@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2920312.TnoQcCR5HX@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 04:39:50PM +0100, Bartlomiej Zolnierkiewicz wrote:
> Make sata_highbank host driver depend on ARCH_HIGHBANK config option
> as Calxeda Highbank SATA support is specific to Calxeda Highbank
> SoCs and the driver to work requires suitable device tree node to
> be defined.  Additionally allow the driver build if COMPILE_TEST
> config option is set.
> 
> Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
> Cc: Rob Herring <robh@kernel.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Applied to libata/for-3.15.

Thanks.

-- 
tejun
