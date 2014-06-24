Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbaFXT60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:58:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbaFXT6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:58:25 -0400
Date: Tue, 24 Jun 2014 15:58:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        satoru.takeuchi@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.15 00/61] 3.15.2-stable review
Message-ID: <20140624195813.GA13898@kroah.com>
References: <20140624154952.751713761@linuxfoundation.org>
 <53A9D69E.2050008@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A9D69E.2050008@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 01:50:54PM -0600, Shuah Khan wrote:
> On 06/24/2014 09:50 AM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.15.2 release.
> >There are 61 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Thu Jun 26 15:49:36 UTC 2014.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.15.2-rc1.gz
> >and the diffstat can be found below.
> >
> >thanks,
> >
> >greg k-h
> >
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing all 4 of these and letting me know.

greg k-h
