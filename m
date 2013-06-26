Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab3FZLsC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:48:02 -0400
Received: from mx3.cyfra.ua ([62.80.160.182]:45976 "EHLO mx3.cyfra.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab3FZLsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:48:00 -0400
From: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Organization: Factor-SPE
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] uio: Remove uio_pdrv and use uio_pdrv_genirq instead
Date: Wed, 26 Jun 2013 14:47:51 +0300
User-Agent: KMail/1.9.10
Cc: Michal Simek <michal.simek@xilinx.com>, Michal Simek <monstr@monstr.eu>,
        Pavel Machek <pavel@ucw.cz>, "Hans J. Koch" <hjk@hansjkoch.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <03c8973cc1e9efcd203e4d95d2dd9469afbcb39b.1372240320.git.michal.simek@xilinx.com> <771234ccdcd59f6918deb4a8690b4b435a9da556.1372240320.git.michal.simek@xilinx.com>
In-Reply-To: <771234ccdcd59f6918deb4a8690b4b435a9da556.1372240320.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201306261447.51766.vitas@nppfactor.kiev.ua>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 June 2013 12:52:12 Michal Simek wrote:
> The patch "UIO: fix uio_pdrv_genirq with device tree but no interrupt"
> (sha1: e3a3c3a205554e564751cd9c0276b2af813d7a92)
> add support to use this driver with no interrupts.
> uio_pdrv_genirq also supports device-tree binding
> which is not available in uio_pdrv.
> 
> That's why this uio_pdrv driver can be just removed.
> 

The idea is sound and I like it - it removes a lot of duplicated code.

Reviewed-by: Vitalii Demianets <vitas@nppfactor.kiev.ua>
