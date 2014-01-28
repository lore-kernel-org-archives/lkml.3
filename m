Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbaA1Q07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 11:26:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbaA1Q06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 11:26:58 -0500
Date: Tue, 28 Jan 2014 08:28:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Jon Medhurst <tixy@linaro.org>, Alexandre Courbot <acourbot@nvidia.com>,
        stable@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: Possible stable fix for decompressor speed
Message-ID: <20140128162806.GB6972@kroah.com>
References: <20140128161428.GO11841@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140128161428.GO11841@sirena.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 04:14:28PM +0000, Mark Brown wrote:
> The changes in patch 1431574a1c4c (lib/decompressors: fix "no limit"
> output buffer length) avoid doing decompression a byte at a time when
> decompressing into high physical addresses using a small, well isolated
> change.  The patch can give a very noticable improvement in kernel boot
> times on affected systems, for example with one ARM system this reduces
> the total time to boot the kernel by more than a third.
> 
> Would you consider this patch for stable?  It doesn't quite fit within
> the criteria but you've indicated in the past that such isolated and
> well supported changs can be acceptable anyway.  If it's not OK for
> stable it seems like it should be a good candidate for LTSI.

It's a one-line change that seems well tested and provides a noticed
speedup, so yes, I can take it for the 3.10-stable tree, thanks.

greg k-h
