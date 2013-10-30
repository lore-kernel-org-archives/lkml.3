Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab3J3LUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:20:10 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:54577 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab3J3LUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:20:04 -0400
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v3)
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        jsvogt@de.ibm.com, MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com,
        michael@ibmra.de, Frank Haverkamp <haver@vnet.ibm.com>
In-Reply-To: <20131025152146.GA27323@kroah.com>
References: <20131024100942.GA13614@kroah.com>
	 <1382695784-10127-2-git-send-email-haver@linux.vnet.ibm.com>
	 <20131025104212.GA22369@kroah.com>
	 <1382709644.8698.31.camel@oc7383187364.ibm.com>
	 <20131025152146.GA27323@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 30 Oct 2013 12:19:58 +0100
Message-ID: <1383131998.16560.106.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103011-0342-0000-0000-000006B580D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Am Freitag, den 25.10.2013, 16:21 +0100 schrieb Greg KH:
> On Fri, Oct 25, 2013 at 04:00:44PM +0200, Frank Haverkamp wrote:
> > > And why are you doing debug stuff through the ioctl interface?  Please
> > > move that to debugfs if you really want/need that information, it does
> > > not belong in an ioctl.
> > 
> > I will look into that. We need that information per card when it fails.
> 
> People put per-card information in debugfs all the time, look at the USB
> host controller files in debugfs for an example of how to do this.

Thanks for pointing me to the example. I moved some of my former sysfs
interfaces to debugfs. Especially those which were printing out more
than one item. I guess you don't like those in sysfs anyways.

> thanks,
> 
> greg k-h
> 

I re-posted our driver in "[PATCH] Generic WorkQueue Engine (GenWQE)
device driver (v4)" and addressed Ryans comments too.

Some of the module parameters I got rid of, some others I turned into
debugfs interfaces. Again others I replaced by constants with proven
default values. For those I kept, I added comments why I want them as
parameters still.

Regards

Frank

