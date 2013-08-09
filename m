Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030351Ab3HIDy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 23:54:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56548 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967387Ab3HIDy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 23:54:57 -0400
Date: Thu, 8 Aug 2013 20:56:20 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/22] 3.0.90-stable review
Message-ID: <20130809035620.GA9454@kroah.com>
References: <20130809013949.226228694@linuxfoundation.org>
 <52046514.3000804@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52046514.3000804@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 08:42:12PM -0700, Guenter Roeck wrote:
> On 08/08/2013 06:41 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.0.90 release.
> >There are 22 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Sun Aug 11 01:37:07 UTC 2013.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.90-rc1.gz
> >and the diffstat can be found below.
> >
> 
> Cross build results:
> 	Total builds: 58 Total build errors: 14
> 
> Same result as with previous release, except I got the m68k builds to work on 3.0,
> added some new builds, and removed others which were failing on all branches.

Thanks for testing and letting me know.

greg k-h
