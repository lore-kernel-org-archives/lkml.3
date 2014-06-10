Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaFJSmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:42:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaFJSmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:42:18 -0400
Date: Tue, 10 Jun 2014 11:46:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.14 00/78] 3.14.7-stable review
Message-ID: <20140610184607.GC15811@kroah.com>
References: <20140609224813.282275135@linuxfoundation.org>
 <8761k8zyj2.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761k8zyj2.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 10:26:09PM +0900, Satoru Takeuchi wrote:
> Hi Greg,
> 
> At Mon,  9 Jun 2014 15:47:40 -0700,
> Greg Kroah-Hartman wrote:
> > 
> > This is the start of the stable review cycle for the 3.14.7 release.
> > There are 78 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed Jun 11 22:47:49 UTC 2014.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.7-rc1.gz
> > and the diffstat can be found below.
> 
> 3.14.7-rc1, 3.10.43-rc1, and 3.4.93-rc1 passed my test.
> 
>  - Test Cases:
>    - Build this kernel.
>    - Boot this kernel.
>    - Build the latest mainline kernel with this kernel.
> 
>  - Test Tool:
>    https://github.com/satoru-takeuchi/test-linux-stable
> 
>  - Test Result (kernel .config, ktest config and test log):
>    http://satoru-takeuchi.org/test-linux-stable/results/<version>-<test datetime>.tar.xz
> 
>  - Build Environment:
>    - OS: Debian Jessy x86_64
>    - CPU: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz x 4
>    - memory: 8GB
> 
>  - Test Target Environment:
>    - Debian Jessy x86_64 (KVM guest on the Build Environment)
>    - # of vCPU: 2
>    - memory: 2GB

Thanks for testing these and letting me know.

greg k-h
