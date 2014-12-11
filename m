Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934212AbaLKJAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 04:00:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:5742 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227AbaLKJAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 04:00:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,556,1413270000"; 
   d="scan'208";a="645942002"
Date: Thu, 11 Dec 2014 10:58:01 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        benjamin.tissoires@redhat.com, aduggan@synaptics.com, jkosina@suse.cz
Subject: Re: NULL pointer dereference in i2c-hid
Message-ID: <20141211085801.GR1300@lahna.fi.intel.com>
References: <31518562.V5Oyo0POsI@xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31518562.V5Oyo0POsI@xps13>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 06:04:51PM +0100, Gabriele Mazzotta wrote:
> my laptop uses a touchpad that needs hid-rmi along with i2c-hid to work.
> i2c-hid and hid-rmi can be loaded and unloaded independelty from each
> other, however since 34f439e4afcd ("HID: i2c-hid: add runtime PM support")
> if I unload hid-rmi and after it I also unload i2c-hid, I get a NULL
> pointer dereference.

I'll look into this.

I can reproduce this easily with i2c-hid + hid-multitouch following your
directions.
