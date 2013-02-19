Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116Ab3BSPP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:15:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:41651 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932551Ab3BSPPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:15:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,696,1355126400"; 
   d="scan'208";a="289085898"
Date: Tue, 19 Feb 2013 17:20:08 +0200
From: "Westerberg, Mika" <mika.westerberg@intel.com>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: How to populate Battery information through ACPI tables
Message-ID: <20130219152008.GG2439@intel.com>
References: <D854C92F57B1B347B57E531E78D05EAD24661392@BGSMSX102.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D854C92F57B1B347B57E531E78D05EAD24661392@BGSMSX102.gar.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 03:07:57PM +0000, Pallala, Ramakrishna wrote:
> I am trying to populate battery related information through ACPI tables
> and do battery management through non acpi drivers.  Can you tell or
> point me on how to populate the ACPI tables in FW/BIOS and get them in
> OS? I am new to ACPI world.

You should start by reading Documentation/acpi/enumeration.txt.

Also can you describe with bit more details, what you are trying to do? A
new battery driver that is enumerated from ACPI namespace, perhaps?

Do you have a DSDT table in hand which we could take a peek?
