Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab3HIE0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 00:26:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab3HIE0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 00:26:23 -0400
Date: Thu, 8 Aug 2013 21:27:46 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ 000/102] 3.10.6-stable review
Message-ID: <20130809042746.GA10127@kroah.com>
References: <20130809015010.208118575@linuxfoundation.org>
 <201308090613.06774.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201308090613.06774.s.L-H@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 06:13:02AM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Friday 09 August 2013, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.10.6 release.
> […]
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.6-rc1.gz
> […]
> 
> There appears to be a problem with the mirroring (not pushed?):
> 
> $ LANG= wget kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.6-rc1.gz
> --2013-08-09 06:05:02--  http://kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.6-rc1.gz
> Resolving kernel.org (kernel.org)... 149.20.4.69, 198.145.20.140
> Connecting to kernel.org (kernel.org)|149.20.4.69|:80... connected.
> HTTP request sent, awaiting response... 301 Moved Permanently
> Location: https://www.kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.6-rc1.gz [following]
> --2013-08-09 06:05:02--  https://www.kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.6-rc1.gz
> Resolving www.kernel.org (www.kernel.org)... 198.145.20.140, 149.20.4.69
> Connecting to www.kernel.org (www.kernel.org)|198.145.20.140|:443... connected.
> HTTP request sent, awaiting response... 404 Not Found
> 2013-08-09 06:05:06 ERROR 404: Not Found.
> 
> The other -stable patches of this round
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.57-rc1.gz
> and
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.90-rc1.gz
> appear to be missing as well.

Yes, something up with the kernel.org backend, I have a support ticket
already opened up on this.  Due to different timezones, it might take 12
hours or so before people wake up, so please be patient.

> Using the current queue-3.10/series from 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
> builds and works fine on x86_64 and i386.

That's good to hear, thanks for testing and letting me know.

greg k-h
