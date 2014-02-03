Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaBCN7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 08:59:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42872 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaBCN7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 08:59:18 -0500
Date: Mon, 3 Feb 2014 13:59:12 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jon Medhurst <tixy@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>, stable@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: Possible stable fix for decompressor speed
Message-ID: <20140203135912.GC5258@hercules>
References: <20140128161428.GO11841@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140128161428.GO11841@sirena.org.uk>
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

Thanks Mark, I'm queuing this for the 3.5 and the 3.11 kernels as well.

Cheers,
--
Luis
