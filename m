Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab3BRJ02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 04:26:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45505 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609Ab3BRJ00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 04:26:26 -0500
Date: Mon, 18 Feb 2013 10:26:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Pandruvada, Srinivas" <srinivas.pandruvada@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: RE: [PATCH 2/3] HID: sensor-hub: get rid of unused sensor_hub_grabbed_usages[]
 table
In-Reply-To: <4FA419E87744DF4DAECD5BCE1214B7A91E00EB72@ORSMSX108.amr.corp.intel.com>
Message-ID: <alpine.LNX.2.00.1302181024400.17024@pobox.suse.cz>
References: <1360578679-7029-1-git-send-email-mika.westerberg@linux.intel.com> <1360578679-7029-2-git-send-email-mika.westerberg@linux.intel.com> <4FA419E87744DF4DAECD5BCE1214B7A91E00EB72@ORSMSX108.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2013, Pandruvada, Srinivas wrote:

> This was added to load sensor hub driver on USB plug in without explicit modprobe. 
> But with last few changes to remove vendor and product id, we need to do modprobe this driver.
> So removal is OK.

Srinivas,

sorry, I have a hard time parsing your message.

The modprobing should work just fine with HID_GROUP_SENSOR_HUB, this has 
nothing to do with ->usage_table callback.

-- 
Jiri Kosina
SUSE Labs
