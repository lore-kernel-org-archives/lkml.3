Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab3FZXRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:17:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54967 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab3FZXRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:17:08 -0400
Date: Thu, 27 Jun 2013 01:17:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 2/2] uio: Remove uio_pdrv and use uio_pdrv_genirq
 instead
Message-ID: <20130626231706.GA13166@amd.pavel.ucw.cz>
References: <03c8973cc1e9efcd203e4d95d2dd9469afbcb39b.1372240320.git.michal.simek@xilinx.com>
 <771234ccdcd59f6918deb4a8690b4b435a9da556.1372240320.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <771234ccdcd59f6918deb4a8690b4b435a9da556.1372240320.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-06-26 11:52:12, Michal Simek wrote:
> The patch "UIO: fix uio_pdrv_genirq with device tree but no interrupt"
> (sha1: e3a3c3a205554e564751cd9c0276b2af813d7a92)
> add support to use this driver with no interrupts.
> uio_pdrv_genirq also supports device-tree binding
> which is not available in uio_pdrv.
> 
> That's why this uio_pdrv driver can be just removed.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Reviewed-by: Pavel Machek <pavel@denx.de>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
