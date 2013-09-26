Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab3IZBJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:09:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab3IZBJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:09:17 -0400
Date: Wed, 25 Sep 2013 18:09:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 000/117] 3.11.2-stable review
Message-ID: <20130926010916.GB21670@kroah.com>
References: <20130925001740.833541979@linuxfoundation.org>
 <524261F0.20202@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524261F0.20202@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 09:09:20PM -0700, Guenter Roeck wrote:
> On 09/24/2013 05:17 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.11.2 release.
> >There are 117 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Fri Sep 27 00:16:31 UTC 2013.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.2-rc1.gz
> >and the diffstat can be found below.
> >
> 
> Build test results:
> 	total: 110 pass: 108 skipped: 2 fail: 0
> 
> 3.11.1 had one failure (xtensa:allmodconfig) which has been fixed.

That's good to see, thanks for testing and letting me know.

greg k-h
