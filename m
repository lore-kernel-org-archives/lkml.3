Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaA0Nd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 08:33:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33725 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbaA0Nd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 08:33:27 -0500
Date: Mon, 27 Jan 2014 05:34:32 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/12] 3.4.78-stable review
Message-ID: <20140127133432.GA19824@kroah.com>
References: <20140126030451.934281002@linuxfoundation.org>
 <87sis9oes1.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sis9oes1.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 08:17:02PM +0900, Satoru Takeuchi wrote:
> At Sat, 25 Jan 2014 19:05:03 -0800,
> Greg Kroah-Hartman wrote:
> > 
> > This is the start of the stable review cycle for the 3.4.78 release.
> > There are 12 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue Jan 28 03:04:41 UTC 2014.
> > Anything received after that time might be too late.
> 
> This kernel passed my test.
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

greg k-h
