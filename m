Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab3EUQyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 12:54:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab3EUQyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 12:54:02 -0400
Date: Tue, 21 May 2013 09:54:01 -0700
From: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] [3.10] mei: bus: Reset event_cb when disabling a device
Message-ID: <20130521165401.GA8822@kroah.com>
References: <20130521135817.GE4589@zurbaran>
 <5B8DA87D05A7694D9FA63FD143655C1B01F2E489@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B01F2E489@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 03:01:27PM +0000, Winkler, Tomas wrote:
> 
> 
> > -----Original Message-----
> > From: Samuel Ortiz [mailto:sameo@linux.intel.com]
> > Sent: Tuesday, May 21, 2013 16:58
> > To: Winkler, Tomas
> > Cc: linux-kernel
> > Subject: [PATCH] [3.10] mei: bus: Reset event_cb when disabling a device
> > 
> > After cancelling all reads from the disable hook, we need to reset the
> > event_cb pointer as well or else we won't be able to set a new one up when
> > re-enabling the device.
> > 
> > Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> Acked.

Nice, but can someone actually send me the patch to apply?

thanks,

greg k-h
