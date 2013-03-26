Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab3CZTD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:03:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48853 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222Ab3CZTD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:03:56 -0400
Date: Tue, 26 Mar 2013 19:03:52 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Message-ID: <20130326190352.GO9079@decadent.org.uk>
References: <20130325010524.240972766@decadent.org.uk>
 <87obe6e2m1.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87obe6e2m1.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 000/104] 3.2.42-stable review
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 10:01:58PM +0900, Satoru Takeuchi wrote:
> At Mon, 25 Mar 2013 00:34:24 +0000,
> Ben Hutchings wrote:
> > 
> > This is the start of the stable review cycle for the 3.2.42 release.
> > There are 104 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed Mar 27 01:00:00 UTC 2013.
> > Anything received after that time might be too late.
> > 
> > A combined patch relative to 3.2.41 will be posted as an additional
> > response to this.  A shortlog and diffstat can be found below.
> 
> This kernel can be built and boot without any problem.
> Building a kernel with this kernel also works fine.
> 
>  - Build Machine: debian wheezy x86_64
>    CPU: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz x 4
>    memory: 8GB
> 
>  - Test machine: debian wheezy x86_64(KVM guest on the Build Machine)
>    vCPU: x2
>    memory: 2GB

Thanks.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
