Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbaGQVXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 17:23:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbaGQVXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 17:23:40 -0400
Date: Thu, 17 Jul 2014 14:23:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.15 00/84] 3.15.6-stable review
Message-ID: <20140717212316.GB2991@kroah.com>
References: <20140715231713.193785557@linuxfoundation.org>
 <20140716230902.GA13304@kroah.com>
 <53C714EC.7030203@roeck-us.net>
 <20140717015045.GC6509@kroah.com>
 <878unscgn9.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878unscgn9.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 09:29:46PM +0900, Satoru Takeuchi wrote:
> At Wed, 16 Jul 2014 18:50:45 -0700,
> Greg Kroah-Hartman wrote:
> > 
> > On Wed, Jul 16, 2014 at 05:12:28PM -0700, Guenter Roeck wrote:
> > > On 07/16/2014 04:09 PM, Greg Kroah-Hartman wrote:
> > > >On Tue, Jul 15, 2014 at 04:16:57PM -0700, Greg Kroah-Hartman wrote:
> > > >>This is the start of the stable review cycle for the 3.15.6 release.
> > > >>There are 84 patches in this series, all will be posted as a response
> > > >>to this one.  If anyone has any issues with these being applied, please
> > > >>let me know.
> > > >>
> > > >>Responses should be made by Thu Jul 17 23:17:00 UTC 2014.
> > > >>Anything received after that time might be too late.
> > > >>
> > > >>The whole patch series can be found in one patch at:
> > > >>	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.15.6-rc1.gz
> > > >>and the diffstat can be found below.
> > > >
> > > >Due to some problems with Xen, I've removed a bunch of patches from this
> > > >series (and the 3.4, 3.10, and 3.14 series) and done a -rc2 release with
> > > >the updated set:
> > > >
> > > >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.15.6-rc2.gz
> > > >
> > > 
> > > Build and qemu test for all releases is still fine.
> > 
> > Great, thanks for letting me know.
> > 
> > greg k-h
> 
> All -rc2es passed my test too.

Wonderful, thanks.

greg k-h
