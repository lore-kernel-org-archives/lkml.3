Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3LSQKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:10:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab3LSQKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:10:20 -0500
Date: Thu, 19 Dec 2013 08:10:22 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ryo Munakata <ryomnktml@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.12 000/118] 3.12.6-stable review
Message-ID: <20131219161022.GA29408@kroah.com>
References: <20131218211219.461663463@linuxfoundation.org>
 <20131220005851.14c72baecfcf67d33877d996@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220005851.14c72baecfcf67d33877d996@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 12:58:51AM +0900, Ryo Munakata wrote:
> On Wed, 18 Dec 2013 13:10:37 -0800
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > This is the start of the stable review cycle for the 3.12.6 release.
> > There are 118 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri Dec 20 21:12:03 UTC 2013.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.6-rc1.gz
> > and the diffstat can be found below.
> 
> 
> Results:
> 	Target:		3.12.6-rc2
> 	Patching:	No errors
> 	Compilation:	No errors
> 	Boot:		No errors
> 	dmesg:		No regressions compared to the previous stable kernel
> 
> 	Looks good to me.

Thanks for testing and letting me know.

greg k-h
