Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbbAYQVc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:21:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbbAYQPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:15:39 -0500
Date: Sun, 25 Jan 2015 20:01:22 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Surya Seetharaman <surya.seetharaman9@gmail.com>,
        Keerthimai Janarthanan <keerthimaipb@gmail.com>,
        Tina Johnson <tinajohnson.1234@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Fabio Falzoi <fabio.falzoi84@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: rts5208: use msecs_to_jiffies for timeouts
Message-ID: <20150125120122.GA14049@kroah.com>
References: <1421997353-12781-1-git-send-email-der.herr@hofr.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421997353-12781-1-git-send-email-der.herr@hofr.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 08:15:53AM +0100, Nicholas Mc Guire wrote:
> This is only an API consolidation and should make things more readable
> 
> Converting milliseconds to jiffies by val * HZ / 1000 is technically
> not wrong but msecs_to_jiffies(val) is the cleaner solution and handles
> corner cases correctly.
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
> 
> v2: typo in patch subject fixed - no change in actual patch
> 
> This patch was only compile tested with x86_64_defconfig + CONFIG_STAGING=y, 
> CONFIG_RTS5208=m
> 
> Patch is against 3.19.0-rc5 -next-20150122
> 
>  drivers/staging/rts5208/rtsx_transport.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Applied, thanks.

greg k-h
