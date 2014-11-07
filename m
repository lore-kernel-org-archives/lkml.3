Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaKGTXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 14:23:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbaKGTXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 14:23:11 -0500
Date: Fri, 7 Nov 2014 11:23:10 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
Subject: Re: [PATCH v5 00/11] drivers: cacheinfo support
Message-ID: <20141107192310.GB30923@kroah.com>
References: <1412084912-2767-1-git-send-email-sudeep.holla@arm.com>
 <5445587B.8090203@arm.com>
 <20141020184932.GA25398@kroah.com>
 <544626AD.403@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544626AD.403@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 10:26:05AM +0100, Sudeep Holla wrote:
> Hi Greg,
> 
> On 20/10/14 19:49, Greg Kroah-Hartman wrote:
> >On Mon, Oct 20, 2014 at 07:46:19PM +0100, Sudeep Holla wrote:
> >>Hi Greg,
> >>
> >>On 30/09/14 14:48, Sudeep Holla wrote:
> >>>This series adds a generic cacheinfo support similar to topology. The
> >>>implementation is based on x86 cacheinfo support. Currently x86, powerpc,
> >>>ia64 and s390 have their own implementations. While adding similar support
> >>>to ARM and ARM64, here is the attempt to make it generic quite similar to
> >>>topology info support. It also adds the missing ABI documentation for
> >>>the cacheinfo sysfs which is already being used.
> >>>
> >>>It moves all the existing different implementations on x86, ia64, powerpc
> >>>and s390 to use the generic cacheinfo infrastructure introduced here.
> >>>These changes on non-ARM platforms are only compile tested and tested on x86.
> >>>
> >>>This series also adds support for ARM and ARM64 architectures based on
> >>>the generic support.
> >>>
> >>>The code can be fetched from:
> >>>  git://linux-arm.org/linux-skn cacheinfo
> >>>
> >>
> >>I am hoping to target this for v3.19 if possible, it would be good if
> >>you can review and provide feedback.
> >
> >3.18-rc1 just came out a few _hours_ ago, and now we can start worrying
> >about what goes into 3.19.  I have 1257 emails in my "to-review" queue
> >for 3.19, please give me a chance to catch up in a few weeks to get to
> >this code.
> >
> 
> I completely understand and I am sorry if that was a noise.
> I just wanted to ensure it's not lost, thanks for letting me know it's
> in your list.

Do you want me to take this through my tree?  If so, I will, otherwise,
feel free to add:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

to the series.

thanks,

greg k-h
