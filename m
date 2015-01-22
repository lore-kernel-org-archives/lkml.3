Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbbAVLgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:36:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbbAVLga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:36:30 -0500
Date: Thu, 22 Jan 2015 19:35:30 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Gabriel Laskar <gabriel@lse.epita.fr>
Cc: Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: ashmem - missing linux/types.h in header.
Message-ID: <20150122113530.GA3638@kroah.com>
References: <1421918692-5872-1-git-send-email-gabriel@lse.epita.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421918692-5872-1-git-send-email-gabriel@lse.epita.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 10:24:49AM +0100, Gabriel Laskar wrote:
> struct ashmem_pin uses __u32 types that are defined in linux/types.h.
> 
> Signed-off-by: Gabriel Laskar <gabriel@lse.epita.fr>
> ---
>  drivers/staging/android/uapi/ashmem.h | 1 +
>  1 file changed, 1 insertion(+)

What is broken without this change?  Is something failing to build?

thanks,

greg k-h
