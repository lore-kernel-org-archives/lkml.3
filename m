Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab3FZDhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 23:37:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3FZDg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 23:36:59 -0400
Date: Tue, 25 Jun 2013 20:37:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/27] 3.4.51-stable review
Message-ID: <20130626033744.GB27004@kroah.com>
References: <20130625183517.651770593@linuxfoundation.org>
 <20130625193925.GB10427@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625193925.GB10427@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 12:39:25PM -0700, Guenter Roeck wrote:
> On Tue, Jun 25, 2013 at 11:35:19AM -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.4.51 release.
> > There are 27 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu Jun 27 18:33:29 UTC 2013.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.51-rc1.gz
> > and the diffstat can be found below.
> > 
> Build results are as follows. Most failures are due to
> 
> 	bonding: rlb mode of bond should not alter ARP originating via bridge

Thanks for testing, hopefully we get that straightened out soon...

greg k-h
