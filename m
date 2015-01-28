Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761060AbbA1UhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:37:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbbA1UhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:37:20 -0500
Date: Wed, 28 Jan 2015 11:21:42 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Simon Guo <wei.guo.simon@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.19.0-rc5 01/03] STAGING: Fix pcl818.c coding style
 issue: code indent should use tabs where possible
Message-ID: <20150128192142.GA17038@kroah.com>
References: <20150126131627.GA9183@thunderCat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126131627.GA9183@thunderCat>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 09:16:28PM +0800, Simon Guo wrote:
> Correct one coding style problem(detected by checkpatch.pl) in pcl818.c.
> - code indent should use tabs where possible
> It is fixed by reformatting the comment block to usual comment style.
> 
> Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>
> ---
>  drivers/staging/comedi/drivers/pcl818.c | 195 ++++++++++++++++----------------
>  1 file changed, 97 insertions(+), 98 deletions(-)

When you resend patches, please let me know what version of the patch
series this is, with a "v2" or something in the subject area.

Right now I see a bunch of patches from you, but no clue as to which is
the 'latest' and what changed in what version.

So I'm going to drop them all, please resend.

Also, you don't need the kernel version in the [PATCH] area, as we are
always assuming you are making the patch against the latest kernel
version, hopefully my staging-testing branch, otherwise we couldn't
apply it no matter what.

thanks,

greg k-h
