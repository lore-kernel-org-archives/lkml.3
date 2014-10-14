Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaJNClJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 22:41:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbaJNClH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 22:41:07 -0400
Date: Tue, 14 Oct 2014 04:40:04 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.17 00/25] 3.17.1-stable review
Message-ID: <20141014024004.GC27498@kroah.com>
References: <20141013022454.289398272@linuxfoundation.org>
 <543C379D.3060107@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543C379D.3060107@osg.samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 02:35:41PM -0600, Shuah Khan wrote:
> On 10/12/2014 08:24 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.17.1 release.
> > There are 25 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed Oct 15 02:24:45 UTC 2014.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.17.1-rc1.gz
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Compiled and booted on my test system. No dmesg regressions noticed
> compared to 3.17. Ran kselftest target as it is included in this
> release. Didn't notice any breakages.

Yeah, kselftest!  I had forgotten that was operational in this release,
I'll go add it to my release scripts to make sure it is run before I cut
an -rc.

Thanks for testing all of these and letting me know.

greg k-h
