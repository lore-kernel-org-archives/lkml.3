Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644AbaFLQHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:07:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933602AbaFLQG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:06:59 -0400
Date: Thu, 12 Jun 2014 09:10:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jimmy P <jimmyp11f155@gmail.com>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: iio: fix coding style
Message-ID: <20140612161050.GA12586@kroah.com>
References: <1402566163-9860-1-git-send-email-jimmyp11f155@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402566163-9860-1-git-send-email-jimmyp11f155@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 05:42:43PM +0800, Jimmy P wrote:
> This patch fixes coding style errors reported by checkpatch.pl for
> lines that was over 80 chars long. The macro value shoud be put in () as
> well.
> 
> Signed-off-by: Jimmy P <jimmyp11f155@gmail.com>

We need a "real" or "full" name here for the signed-off-by: line, please
read Documentation/SubmittingPatches for the full details as to what
this line means and why we need that.

Also, this patch does multiple things, please break it up into different
patches, each only doing one specific thing.

thanks,

greg k-h
