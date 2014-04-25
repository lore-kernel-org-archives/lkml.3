Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaDYBsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:48:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41386 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaDYBsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:48:33 -0400
Date: Thu, 24 Apr 2014 18:49:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/23] 3.10.38-stable review
Message-ID: <20140425014907.GA27190@kroah.com>
References: <20140424214825.933835556@linuxfoundation.org>
 <5359A9E2.1010202@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5359A9E2.1010202@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 05:18:42PM -0700, Guenter Roeck wrote:
> On 04/24/2014 02:48 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.10.38 release.
> > There are 23 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat Apr 26 21:48:09 UTC 2014.
> > Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 126 pass: 122 skipped: 4 fail: 0
> 
> Qemu tests all passed. Results are as expected.
> 
> Details are available at http://server.roeck-us.net:8010/builders.
> 
> But wait ... I have 24 patches in this series, not 23. Did you add one ?

I count 23, I removed one a few days ago, did your scrips miss that?

thanks for testing,

greg k-h
