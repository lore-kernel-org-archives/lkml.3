Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761881Ab3JQBGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 21:06:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761322Ab3JQBGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 21:06:35 -0400
Date: Wed, 16 Oct 2013 18:07:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/69] 3.10.17-stable review
Message-ID: <20131017010744.GB1432@kroah.com>
References: <20131016174312.844154919@linuxfoundation.org>
 <20131016221146.GA18209@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016221146.GA18209@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 03:11:46PM -0700, Guenter Roeck wrote:
> On Wed, Oct 16, 2013 at 10:44:09AM -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.10.17 release.
> > There are 69 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > You might notice a bunch of ipc patches in this series.  That is to
> > resolve some reported ipc bugs / scalabity issues.  Additional testing
> > of these code paths would be greatly appreciated.
> > 
> > Responses should be made by Fri Oct 18 17:41:53 UTC 2013.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.17-rc1.gz
> > and the diffstat can be found below.
> > 
> 
> Build results:
> 	total: 110 pass: 110 skipped: 0 fail: 0
> 
> qemu tests all pass, with the usual warning for the 'sh' target.
> 
> Details are at http://server.roeck-us.net:8010/builders.

Great, thanks for testing and letting me know.

greg k-h
