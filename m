Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab3JCSlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:41:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab3JCSlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:41:09 -0400
Date: Thu, 3 Oct 2013 11:41:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/57] 3.11.4-stable review
Message-ID: <20131003184125.GD8901@kroah.com>
References: <20131003040636.600441214@linuxfoundation.org>
 <524D72A8.6080202@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524D72A8.6080202@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 06:35:36AM -0700, Guenter Roeck wrote:
> On 10/02/2013 09:08 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.11.4 release.
> > There are 57 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat Oct  5 04:06:23 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.4-rc1.gz
> > and the diffstat can be found below.
> >
> 
> Build results:
> 	total: 110 pass: 108 skipped: 2 fail: 0
> 
> qemu tests all passed, with the usual warning for sh.
> 
> Details are available at http://server.roeck-us.net:8010/builders.
> Note that 'skipped' does not indicate a fauilure. It means that the
> to-be-tested configuration does not exist in this kernel version.

Thanks for the explaination, looks good, thanks.

greg k-h
