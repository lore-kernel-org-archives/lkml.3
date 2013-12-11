Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3LKBPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:15:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab3LKBPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:15:52 -0500
Date: Tue, 10 Dec 2013 17:17:23 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/52] 3.10.24-stable review
Message-ID: <20131211011723.GC5756@kroah.com>
References: <20131210075954.196229872@linuxfoundation.org>
 <20131210170344.GB15940@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210170344.GB15940@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 09:03:44AM -0800, Guenter Roeck wrote:
> On Tue, Dec 10, 2013 at 12:00:33AM -0800, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.10.24 release.
> > There are 52 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu Dec 12 07:59:40 UTC 2013.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 110 pass: 109 skipped: 0 fail: 1
> 
> Build avr32:atngw100mkii_evklcd101_defconfig still fails.

I guess no one cares about avr32 anymore :(

Anyway, thanks for the results,

greg k-h
