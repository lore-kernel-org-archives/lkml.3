Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbaGQVXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 17:23:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbaGQVX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 17:23:29 -0400
Date: Thu, 17 Jul 2014 14:23:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        satoru.takeuchi@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.15 00/84] 3.15.6-stable review
Message-ID: <20140717212304.GA2991@kroah.com>
References: <20140715231713.193785557@linuxfoundation.org>
 <53C7CE8D.1050200@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C7CE8D.1050200@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 07:24:29AM -0600, Shuah Khan wrote:
> On 07/15/2014 05:16 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.15.6 release.
> >There are 84 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Thu Jul 17 23:17:00 UTC 2014.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.15.6-rc1.gz
> >and the diffstat can be found below.
> >
> >thanks,
> >
> >greg k-h
> >
> 
> rc1 and rc2 compiled and booted on my test system. No dmesg regressions.

Thanks for testing all of these and letting me know.

greg k-h
