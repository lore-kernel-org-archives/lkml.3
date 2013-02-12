Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab3BLJIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 04:08:18 -0500
Received: from mga03.intel.com ([143.182.124.21]:33179 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131Ab3BLJIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 04:08:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,648,1355126400"; 
   d="scan'208";a="201397740"
Date: Tue, 12 Feb 2013 11:12:05 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Pandruvada, Srinivas" <srinivas.pandruvada@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH 3/3] HID: sensor-hub: don't limit the driver only to USB
 bus
Message-ID: <20130212091205.GO20771@intel.com>
References: <1360578679-7029-1-git-send-email-mika.westerberg@linux.intel.com>
 <1360578679-7029-3-git-send-email-mika.westerberg@linux.intel.com>
 <4FA419E87744DF4DAECD5BCE1214B7A91E00FB81@ORSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA419E87744DF4DAECD5BCE1214B7A91E00FB81@ORSMSX108.amr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 03:54:05PM +0000, Pandruvada, Srinivas wrote:
> So finally we can use HID sensor hub over I2C.
> Did you try with any I2C sensor hub?

Yes, we have I2C HID sensor hub here and I tested with it. However, I'm not
that familiar how it should be used except that I can see the sensors under
/sys/bus/platform/devices/HID-SENSOR* and there are iio devices under each
platform device.
