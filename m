Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab3JKWOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 18:14:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981Ab3JKWOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 18:14:06 -0400
Date: Fri, 11 Oct 2013 15:14:05 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [ 00/39] 3.0.100-stable review
Message-ID: <20131011221405.GA18324@kroah.com>
References: <20131011193210.843963685@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011193210.843963685@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 12:34:44PM -0700, Greg Kroah-Hartman wrote:
> --------------------------------
> NOTE: This is going to be the next-to-last 3.0.x release that I do.
>       You should be moving off to the 3.4.x or 3.10.x longterm kernels
>       by now, and not use the 3.0.x kernel unless you have to for some
>       reason.  If anyone has any problems with this, please let me know.
> --------------------------------
> 
> This is the start of the stable review cycle for the 3.0.100 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun Oct 13 19:30:52 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.100-rc1.gz
> and the diffstat can be found below.

Due to a powerpc build breakage in -rc1, I've reverted one patch and
created a -rc2 patch:
 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.100-rc2.gz

thanks,

greg k-h
