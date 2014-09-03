Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936254AbaICXo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:44:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933626AbaICXo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 19:44:57 -0400
Date: Wed, 3 Sep 2014 16:44:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.16 000/125] 3.16.2-stable review
Message-ID: <20140903234457.GC27174@kroah.com>
References: <20140903220623.649748296@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 03:05:57PM -0700, Greg Kroah-Hartman wrote:
> --------------------------
> Note, there are a _lot_ of patches submitted for stable kernels that
> have yet to be applied, well over 200+ at the moment.  Given that this
> series is already over 100 patches, I figured it was a good as a time as
> any to push this out.  Don't worry, if you have emailed/marked patches
> to be included, and they aren't here, wait a few more releases for me to
> catch up, thanks.
> --------------------------
> 
> This is the start of the stable review cycle for the 3.16.2 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri Sep  5 22:06:09 UTC 2014.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.16.2-rc1.gz
> and the diffstat can be found below.

-rc2 is out to resolve some reported issues and remove some patches that
should not have been there (yet):
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.16.2-rc2.gz
