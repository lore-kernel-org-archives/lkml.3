Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbaIOVOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:14:06 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34289 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbaIOVOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:14:01 -0400
Date: Mon, 15 Sep 2014 14:13:58 -0700
From: Darren Hart <dvhart@infradead.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Azael Avalos <coproscefalo@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Subject: Re: [PATCH v2 3/5] toshiba_acpi: Fix accelerometer direction
 reporting
Message-ID: <20140915211358.GA64909@vmdeb7>
References: <1410569437-3066-1-git-send-email-coproscefalo@gmail.com>
 <1410569437-3066-2-git-send-email-coproscefalo@gmail.com>
 <20140915192923.GA61529@vmdeb7>
 <20140915195617.GA3652@kroah.com>
 <541753A3.8010102@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541753A3.8010102@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 02:01:23PM -0700, H. Peter Anvin wrote:
> On 09/15/2014 12:56 PM, Greg Kroah-Hartman wrote:
> > 
> >> I have also suggested this device (2 actually) would be better supported as an
> >> IIO accelerometer device, but even that would change the sysfs interface by
> >> removing these altogether and using the IIO standardized path and accelerometer
> >> interface.
> > 
> > That's a better goal overall, then the "odd" sysfs files are now gone,
> > to be replaced with the standard interface which all tools should
> > already be using.
> > 
> 
> I would definitely agree with that, although I understood there were
> technical concerns with that?
> 
> 	-hpa

Yes, the accelerometer is hidden behind two ACPI HIDs with a very limited polled
position and acceleration threshold interface. I've asked the IIO maintainer if
this would be feasible to use as an IIO device, but have not yet heard back.

Jonathan and linux-iio added to Cc.

-- 
Darren Hart
Intel Open Source Technology Center
