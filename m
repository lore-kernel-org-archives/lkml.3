Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab3JLABE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 20:01:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab3JLABC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 20:01:02 -0400
Date: Fri, 11 Oct 2013 17:01:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 000/135] 3.11.5-stable review
Message-ID: <20131012000100.GA19121@kroah.com>
References: <20131011193945.181603934@linuxfoundation.org>
 <20131011235806.GA5067@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011235806.GA5067@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 04:58:06PM -0700, Guenter Roeck wrote:
> On Fri, Oct 11, 2013 at 12:38:01PM -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.11.5 release.
> > There are 135 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun Oct 13 19:38:31 UTC 2013.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.5-rc1.gz
> > and the diffstat can be found below.
> > 
> Build test looks good:
> 	total: 110 pass: 108 skipped: 2 fail: 0
> 
> qemu tests all pass (with the known warning for the sh target).

Great, thanks for testing and letting me know.

greg k-h
