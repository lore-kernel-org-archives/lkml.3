Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab3KIRKG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 12:10:06 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:56482 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab3KIRKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 12:10:03 -0500
Date: Sat, 9 Nov 2013 09:12:29 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/26] 3.4.69-stable review
Message-ID: <20131109171229.GA27366@kroah.com>
References: <20131109065050.089866597@linuxfoundation.org>
 <527E69B1.20507@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527E69B1.20507@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 09, 2013 at 08:58:25AM -0800, Guenter Roeck wrote:
> On 11/08/2013 10:51 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.4.69 release.
> > There are 26 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Mon Nov 11 06:50:22 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.69-rc1.gz
> > and the diffstat can be found below.
> >
> 
> Build test results:
> 	total: 103 pass: 89 skipped: 10 fail: 4
> 
> qemu tests all pass.
> 
> This matches the results from the previous release.

Great, thanks.

