Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab3I0DP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 23:15:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab3I0DPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 23:15:23 -0400
Date: Thu, 26 Sep 2013 20:15:21 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH CHAR-MISC-NEXT 1/4] Intel MIC Host Driver Sysfs Cleanups.
Message-ID: <20130927031521.GA13086@kroah.com>
References: <cover.1380241770.git.sudeep.dutt@intel.com>
 <14836f009d68ee2fb29501cc711f31176486e2f0.1380241770.git.sudeep.dutt@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14836f009d68ee2fb29501cc711f31176486e2f0.1380241770.git.sudeep.dutt@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 06:09:51PM -0700, Sudeep Dutt wrote:
> + Use DEVICE_ATTR_RO/RW instead of DEVICE_ATTR
> + Use ATTRIBUTE_GROUPS
> 
> These changes were suggested by Greg Kroah-Hartman during the
> code review @ https://lkml.org/lkml/2013/9/6/13
> 
> Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
> Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
> Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
> Signed-off-by: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
> Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
> ---

Ok, new kernel developer 101 training time :)

Your Subject:, while the [PATCH] part is fine the rest of the line needs
to be a bit more descriptive.

As this is the "mic" subsystem, how about something like:
	Subject: [PATCH 1/4] misc: mic: host driver sysfs cleanups

No need for the whole "Intel MIC" stuff.

Also, as I "reported" this, you should have a:
	Reported-by: Greg Kroah-Hartman <...>
line in the patch.

And really, all of those people reviewed and signed off on the patch?
That's great, just not a normal thing.

So, can you resend these 4 patches with those things cleaned up?  Same
thing goes for Joe's patch, he deserves a "Reported-by:" at the very
least, given that he pretty much wrote that whole patch.

thanks,

greg k-h
