Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065Ab3BTJ07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:26:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:9292 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757754Ab3BTJ05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:26:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,699,1355126400"; 
   d="scan'208";a="204356261"
Date: Wed, 20 Feb 2013 11:30:59 +0200
From: "Mika Westerberg (mika.westerberg@linux.intel.com)" 
	<mika.westerberg@linux.intel.com>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>, "Brown, Len" <len.brown@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: Linux ACPI DSDT table editing tools
Message-ID: <20130220093059.GP2439@intel.com>
References: <D854C92F57B1B347B57E531E78D05EAD24663596@BGSMSX102.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D854C92F57B1B347B57E531E78D05EAD24663596@BGSMSX102.gar.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 07:36:32AM +0000, Pallala, Ramakrishna wrote:
> I am looking for tools(Linux or w*****s) for editing ACPI tables.
> Can you advise me some good tools. Also I would like to know how BIOS
> engineers populate the ACPI tables? Which tools they use?

Dunno about the BIOS engineers but I use tools from acpica (acpica.org).
There is ASL (dis)assembler and other useful tools in that.

In addition there is tools/power/acpi/acpidump.c in the kernel source tree
which is extremely useful.
