Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaEUIwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:52:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:36079 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaEUIwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:52:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,878,1392192000"; 
   d="scan'208";a="544112732"
Date: Wed, 21 May 2014 11:52:07 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com
Subject: Re: [PATCH V6 09/11] ACPI: introduce flag .is_master_device
Message-ID: <20140521085207.GR1651@lahna.fi.intel.com>
References: <1400136256-2218-1-git-send-email-rui.zhang@intel.com>
 <1400136256-2218-10-git-send-email-rui.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400136256-2218-10-git-send-email-rui.zhang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 02:44:14PM +0800, Zhang Rui wrote:
> For some ACPI device objects, they represent master devices,
> and their children devices are enumerated by bus controller drivers
> for the buses they are on.
> 
> In this case, we do not want to enumerate their children devices to
> platform bus explicitly in acpi scan code.
> 
> Thus a new flag .is_master_device is introduced in this patch.
> 
> For devices with this flag set, we will not do default enumeration
> for their children.

Is there any particular reason we would like to enumerate everything
below the first device by default?
