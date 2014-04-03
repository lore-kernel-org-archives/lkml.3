Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbaDCWnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:43:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaDCWnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:43:11 -0400
Date: Thu, 3 Apr 2014 15:45:34 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        satoru.takeuchi@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 0/9] 3.10.36-stable review
Message-ID: <20140403224534.GB13754@kroah.com>
References: <20140401040754.479538406@linuxfoundation.org>
 <533B2A88.2010604@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533B2A88.2010604@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 03:07:20PM -0600, Shuah Khan wrote:
> On 03/31/2014 10:08 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.10.36 release.
> >There are 9 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Thu Apr  3 04:07:29 UTC 2014.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.36-rc1.gz
> >and the diffstat can be found below.
> >
> >thanks,
> >
> >greg k-h
> >
> 
> Compiled, booted on all my test systems. No regressions in dmesg.

Thanks for testing all of these.

greg k-h
