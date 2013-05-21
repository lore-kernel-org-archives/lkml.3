Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab3EUQwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 12:52:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:40402 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab3EUQv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 12:51:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,715,1363158000"; 
   d="scan'208";a="341200552"
Date: Tue, 21 May 2013 18:51:49 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: Re: [PATCH] [3.10] mei: bus: Reset event_cb when disabling a device
Message-ID: <20130521165149.GA4566@zurbaran>
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
Greg, I did not initially Cc you and now you don't actually have the patch,
sorry.
Let me re-send the patch with Tomas ACK added.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
