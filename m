Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab3JKWIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 18:08:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3JKWIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 18:08:18 -0400
Date: Fri, 11 Oct 2013 15:08:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 000/110] 3.10.16-stable review
Message-ID: <20131011220816.GA9702@kroah.com>
References: <20131011193807.584188672@linuxfoundation.org>
 <20131011214910.GA9941@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011214910.GA9941@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 02:49:10PM -0700, Guenter Roeck wrote:
> On Fri, Oct 11, 2013 at 12:37:40PM -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.10.16 release.
> > There are 110 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun Oct 13 19:37:01 UTC 2013.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.16-rc1.gz
> > and the diffstat can be found below.
> > 
> Test results look good:
> 	total: 110 pass: 110 skipped: 0 fail: 0
> 
> qemu tests pass for all platforms (except for the usual sh warning).
> 

Great, thanks for letting me know.

greg k-h
