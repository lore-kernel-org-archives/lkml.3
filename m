Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaFFHxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:53:18 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:38307 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaFFHxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:53:16 -0400
Date: Fri, 6 Jun 2014 00:53:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.14 000/228] 3.14.6-stable review
Message-ID: <20140606075310.GC13355@roeck-us.net>
References: <20140604232347.966798903@linuxfoundation.org>
 <20140605232008.GB14136@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605232008.GB14136@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 04:20:08PM -0700, Greg Kroah-Hartman wrote:
> On Wed, Jun 04, 2014 at 04:20:29PM -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.14.6 release.
> > There are 228 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri Jun  6 23:23:11 UTC 2014.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.6-rc1.gz
> > and the diffstat can be found below.
> 
> I've updated the stable tree with the futex patches as lots of people
> have been asking me about them, so here is a -rc2 with them
> incorporated:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.6-rc1.gz
> 

Build and qemu tests are still ok. Same applies to 3.4 and 3.10.

Guenter
