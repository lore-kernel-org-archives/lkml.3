Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab3H0W3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 18:29:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3H0W3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 18:29:02 -0400
Date: Tue, 27 Aug 2013 15:31:21 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/13] 3.4.60-stable review
Message-ID: <20130827223121.GF27592@kroah.com>
References: <20130827010309.850395966@linuxfoundation.org>
 <521C2991.1070504@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521C2991.1070504@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 09:22:41PM -0700, Guenter Roeck wrote:
> On 08/26/2013 06:08 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.4.60 release.
> > There are 13 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu Aug 29 01:03:03 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.60-rc1.gz
> > and the diffstat can be found below.
> >
> 
> Cross build results:
> 	total: 75 pass: 73 fail: 2
> Compared to 3.4.59:
> 	total: 69 pass: 67 fail: 2
> 
> qemu tests:
> 	mips, mips64, ppc, x86, x86_64: pass (boot to login prompt)
> 	arm: skipped
> 
> More builds, more platforms tested, still only two failures. Results look good.

that's great, thanks.

greg k-h
