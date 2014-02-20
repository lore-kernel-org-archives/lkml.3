Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbaBTS17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:27:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbaBTS16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:27:58 -0500
Date: Thu, 20 Feb 2014 10:29:24 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, broonie@linaro.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.13 00/40] 3.13.4-stable review
Message-ID: <20140220182924.GA15290@kroah.com>
References: <20140218224433.337299968@linuxfoundation.org>
 <53054956.4010602@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53054956.4010602@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 05:16:22PM -0700, Shuah Khan wrote:
> On 02/18/2014 03:47 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.13.4 release.
> >There are 40 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Thu Feb 20 22:44:22 UTC 2014.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.4-rc1.gz
> >and the diffstat can be found below.
> >
> >thanks,
> >
> >greg k-h
> >
> 
> Compile tests and boot tests passed.
> 
> On Intel systems, there are no dmesg regressions: emerg, crit, alert, err
> are clean. No regressions in warn.
> 
> On AMD systems, the following new error messages - suspect is to
> drivers/regulator/core.c - patch


Thanks for testing all 4 of these releases, much appreciated.

greg k-h
