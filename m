Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbaLGUOA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 15:14:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaLGUN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 15:13:59 -0500
Date: Sun, 7 Dec 2014 12:13:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Andreas Siegling <andreas.siegling@fau.de>
Cc: devel@linuxdriverproject.org, abbotti@mev.co.uk,
        hsweeten@visionengravers.com, chase.southwood@yahoo.com,
        rickard_strandqvist@spectrumdigital.se, ebru.akagunduz@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-kernel@i4.cs.fau.de, Zhutao Lu <lvzhutao@gmail.com>
Subject: Re: [PATCH] comedi: indent checkpatch errors and warnings fixed
Message-ID: <20141207201357.GA27241@kroah.com>
References: <1417982620-26001-1-git-send-email-andreas.siegling@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417982620-26001-1-git-send-email-andreas.siegling@fau.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2014 at 09:03:40PM +0100, Andreas Siegling wrote:
> This patch fixes all indent errors in drivers/staging/comedi and its
> subdirectories. Since there were no other checkpatch errors, all checkpatch
> errors are fixed by this patch.
> 
> It also fixes indent warnings, which were "no space before tabs",
> "no spaces at the start of a line" and "missing a blank line after declarations".

Those are all different types of warnings, please only do one thing per
patch.  Please break this up into smaller pieces, only doing one thing,
and send this as a series of patches.

thanks,

greg kh
