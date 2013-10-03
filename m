Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3JCSky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:40:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab3JCSkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:40:52 -0400
Date: Thu, 3 Oct 2013 11:41:09 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/52] 3.10.15-stable review
Message-ID: <20131003184109.GC8901@kroah.com>
References: <20131003040522.190209641@linuxfoundation.org>
 <524D71E9.20307@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524D71E9.20307@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 06:32:25AM -0700, Guenter Roeck wrote:
> On 10/02/2013 09:05 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.10.15 release.
> > There are 52 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat Oct  5 04:05:08 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.15-rc1.gz
> > and the diffstat can be found below.
> >
> 
> Build results:
> 	total: 110 pass: 110 skipped: 0 fail: 0
> 
> qemu tests:
> 	All passed, with the usual warning for sh.

Yeah, that looks good, thanks for testing.

greg k-h
