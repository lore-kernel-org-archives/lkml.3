Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968122AbaLLOcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 09:32:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967484AbaLLOcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 09:32:46 -0500
Date: Fri, 12 Dec 2014 09:32:44 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Stefan Agner <stefan@agner.ch>
Cc: jslaby@suse.cz, jingchang.lu@freescale.com, shawn.guo@linaro.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] serial: fsl_lpuart: fix various DMA related issues
Message-ID: <20141212143244.GA2219@kroah.com>
References: <1417134205-4400-1-git-send-email-stefan@agner.ch>
 <677f2c62b6b6c1fe8e16cd38d5f20d47@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <677f2c62b6b6c1fe8e16cd38d5f20d47@agner.ch>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 02:44:06PM +0100, Stefan Agner wrote:
> Any thoughts on this patchset? Would have hopped that it makes it into
> 3.19 as those are mostly fixes.

"mostly"?

I'll get to these after 3.19-rc1 is out, but it really looks like these
will be for 3.20-rc1, unless you break them up into "bugfix only" type
patches.

thanks,

greg k-h
