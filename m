Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab3BRJ3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 04:29:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab3BRJ3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 04:29:05 -0500
Date: Mon, 18 Feb 2013 10:28:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        srinivas.pandruvada@intel.com
Subject: Re: [PATCH 3/3] HID: sensor-hub: don't limit the driver only to USB
 bus
In-Reply-To: <CAN+gG=ECOFVjeWtgxixd6iMdp5HkSBJQE3LPzsLtowjY6D=4tA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1302181028410.17024@pobox.suse.cz>
References: <1360578679-7029-1-git-send-email-mika.westerberg@linux.intel.com> <1360578679-7029-3-git-send-email-mika.westerberg@linux.intel.com> <CAN+gG=ECOFVjeWtgxixd6iMdp5HkSBJQE3LPzsLtowjY6D=4tA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2013, Benjamin Tissoires wrote:

> > We now have two transport mediums: USB and I2C, where sensor hubs can
> > exists. So instead of constraining the driver to only these two we let it
> > to match any HID bus as long as the group is HID_GROUP_SENSOR_HUB.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Thanks a lot Mika, I have now applied the series for 3.9

-- 
Jiri Kosina
SUSE Labs
