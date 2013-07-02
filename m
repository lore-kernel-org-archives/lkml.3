Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab3GBS5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 14:57:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab3GBS52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 14:57:28 -0400
Date: Tue, 2 Jul 2013 11:57:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/26] 3.9.9-stable review
Message-ID: <20130702185727.GF7857@kroah.com>
References: <20130701200729.872850414@linuxfoundation.org>
 <20130702183133.GA27809@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130702183133.GA27809@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 11:31:33AM -0700, Guenter Roeck wrote:
> On Mon, Jul 01, 2013 at 01:09:55PM -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.9.9 release.
> > There are 26 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed Jul  3 20:05:42 UTC 2013.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.9-rc1.gz
> > and the diffstat can be found below.
> > 
> Build results as follows. m5272c3 build is still waiting for patch
> from upstream, otherwise as expected.

Great, thanks for testing and letting us know.

greg k-h
