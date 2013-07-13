Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab3GMEro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 00:47:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3GMErn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 00:47:43 -0400
Date: Fri, 12 Jul 2013 21:48:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 0/8] 3.0.86-stable review
Message-ID: <20130713044839.GA16619@kroah.com>
References: <20130711221931.216612791@linuxfoundation.org>
 <87y59b9jq7.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y59b9jq7.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 01:17:36PM +0900, Satoru Takeuchi wrote:
> At Thu, 11 Jul 2013 15:20:29 -0700,
> Greg Kroah-Hartman wrote:
> > 
> > This is the start of the stable review cycle for the 3.0.86 release.
> > There are 8 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat Jul 13 22:18:05 UTC 2013.
> > Anything received after that time might be too late.
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

Thanks for testing all 4 of these releases and letting me know.

greg k-h

