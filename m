Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbaCES3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 13:29:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbaCES3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 13:29:32 -0500
Date: Wed, 5 Mar 2014 10:31:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.13 000/172] 3.13.6-stable review
Message-ID: <20140305183117.GD9824@kroah.com>
References: <20140304200259.626667112@linuxfoundation.org>
 <87d2i0n5mm.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2i0n5mm.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 10:21:05PM +0900, Satoru Takeuchi wrote:
> At Tue,  4 Mar 2014 12:01:24 -0800,
> Greg Kroah-Hartman wrote:
> > 
> > This is the start of the stable review cycle for the 3.13.6 release.
> > There are 172 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu Mar  6 20:02:29 UTC 2014.
> > Anything received after that time might be too late.
> 
> 3.10.33-rc1 and 3.13.6-rc1 passed my test.
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
>    http://satoru-takeuchi.org/test-linux-stable/results/<version>-<test datetime>.xz
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

Thanks for testing and letting me know.

gre k-h
