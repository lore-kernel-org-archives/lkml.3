Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab3KJPN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 10:13:28 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:65422 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3KJPNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 10:13:08 -0500
Date: Sun, 10 Nov 2013 07:15:37 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.11 00/94] 3.11.8-stable review
Message-ID: <20131110151537.GB26793@kroah.com>
References: <20131109065204.252462489@linuxfoundation.org>
 <871u2o78xz.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u2o78xz.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 10, 2013 at 09:11:36PM +0900, Satoru Takeuchi wrote:
> At Fri,  8 Nov 2013 22:51:06 -0800,
> Greg Kroah-Hartman wrote:
> > 
> > This is the start of the stable review cycle for the 3.11.8 release.
> > There are 94 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> This kernel can be built and boot without any problem.
> Building a kernel with this kernel also works fine.
> 
>  - Build Machine: debian jessy x86_64
>    CPU: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz x 4
>    memory: 8GB
> 
>  - Test machine: debian jessy x86_64(KVM guest on the Build Machine)
>    vCPU: x2
>    memory: 2GB
> 
> I reviewed the following patches and it looks good to me.

Great, thanks for testing and letting me know.

greg k-h
