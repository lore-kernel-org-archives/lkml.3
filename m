Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaFFN6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:58:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaFFN6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:58:18 -0400
Date: Fri, 6 Jun 2014 06:58:13 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 000/214] 3.4.92-stable review
Message-ID: <20140606135813.GC11781@kroah.com>
References: <20140605041639.638675216@linuxfoundation.org>
 <20140605231924.GA14136@kroah.com>
 <20140606044254.GA7452@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140606044254.GA7452@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 09:42:54PM -0700, Guenter Roeck wrote:
> On Thu, Jun 05, 2014 at 04:19:24PM -0700, Greg Kroah-Hartman wrote:
> > On Wed, Jun 04, 2014 at 09:16:03PM -0700, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 3.4.92 release.
> > > There are 214 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sat Jun  7 04:15:47 UTC 2014.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.92-rc1.gz
> > > and the diffstat can be found below.
> > 
> > Given the recent changes in this tree, I've released a -rc2 to handle
> > all of the updates.:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.92-rc1.gz
> > 
> Presumably you mean
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.92-rc2.gz

Doh, yes, cutting and pasting and not changing the number was dumb...

> Same for 3.10 and 3.14.

Yes.

Thanks for testing and verifying it's all good.

greg k-h
