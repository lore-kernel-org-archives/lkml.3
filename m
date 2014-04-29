Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbaD2IC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:02:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:2478 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034AbaD2ICw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:02:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,949,1389772800"; 
   d="scan'208";a="531427764"
Date: Tue, 29 Apr 2014 11:02:46 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: wsa@the-dreams.de, rjw@rjwysocki.net, awilliam@redhat.com, lenb@kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Patch V2 7/9] I2C/ACPI: Add i2c ACPI operation region support
Message-ID: <20140429080246.GE1684@lahna.fi.intel.com>
References: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
 <1398695268-28645-1-git-send-email-tianyu.lan@intel.com>
 <1398695268-28645-8-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398695268-28645-8-git-send-email-tianyu.lan@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 10:27:46PM +0800, Lan Tianyu wrote:
> ACPI 5.0 spec(5.5.2.4.5) defines GenericSerialBus(i2c, spi, uart) operation region.
> It allows ACPI aml code able to access such kind of devices to implement
> some ACPI standard method.

Looks good to me now,

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
