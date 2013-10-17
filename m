Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762020Ab3JQBGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 21:06:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761935Ab3JQBGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 21:06:48 -0400
Date: Wed, 16 Oct 2013 18:07:56 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/50] 3.11.6-stable review
Message-ID: <20131017010756.GC1432@kroah.com>
References: <20131016174358.335646140@linuxfoundation.org>
 <20131016221440.GA18297@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016221440.GA18297@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 03:14:40PM -0700, Guenter Roeck wrote:
> On Wed, Oct 16, 2013 at 10:44:46AM -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.11.6 release.
> > There are 50 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri Oct 18 17:43:24 UTC 2013.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.6-rc1.gz
> > and the diffstat can be found below.
> > 
> 
> Build results:
> 	total: 110 pass: 108 skipped: 2 fail: 0
> 
> qemu tests all passed, with the usual warning for the 'sh' target.

Thanks for testing and letting me know.

greg k-h
