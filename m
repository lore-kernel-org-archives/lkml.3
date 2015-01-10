Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbbAJBtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 20:49:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbbAJBtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 20:49:16 -0500
Date: Fri, 9 Jan 2015 17:49:15 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Simon Guo <wei.guo.simon@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.19.0-rc3 1/1] STAGING: Fix pcl818.c coding style issue
Message-ID: <20150110014915.GA19362@kroah.com>
References: <20150109042003.GA3970@thunderCat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109042003.GA3970@thunderCat>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 12:20:04PM +0800, Simon Guo wrote:
> Correct coding style problem in pcl818.c. The coding style problems(29 
> warnings detected by checkpatch.pl) includes:
> - line over 80 characters
> - There is space before tabs
> The changed file has been verified with checkpatch.pl to be clean for 
> warnings/errors.

Those are different things, so there should be different patches, make
this a series please.

Also fix up your trailing whitespace in the changelog itself.

thanks,

greg k-h
