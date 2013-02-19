Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934617Ab3BSTQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:16:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:64231 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933896Ab3BSTQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:16:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,697,1355126400"; 
   d="scan'208";a="289193619"
Date: Tue, 19 Feb 2013 21:20:16 +0200
From: "Westerberg, Mika" <mika.westerberg@intel.com>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: How to populate Battery information through ACPI tables
Message-ID: <20130219192016.GL2439@intel.com>
References: <D854C92F57B1B347B57E531E78D05EAD24661392@BGSMSX102.gar.corp.intel.com>
 <20130219152008.GG2439@intel.com>
 <D854C92F57B1B347B57E531E78D05EAD2466175B@BGSMSX102.gar.corp.intel.com>
 <20130219174210.GH2439@intel.com>
 <D854C92F57B1B347B57E531E78D05EAD2466187B@BGSMSX102.gar.corp.intel.com>
 <20130219180400.GJ2439@intel.com>
 <D854C92F57B1B347B57E531E78D05EAD24661A83@BGSMSX102.gar.corp.intel.com>
 <20130219183816.GK2439@intel.com>
 <D854C92F57B1B347B57E531E78D05EAD24661DB3@BGSMSX102.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D854C92F57B1B347B57E531E78D05EAD24661DB3@BGSMSX102.gar.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 08:59:29PM +0200, Pallala, Ramakrishna wrote:
> > > Mika, I want to populate this characterization data as device
> > > specific/custom data which could be anything And may not be entirely
> > > related to battery. Is this is possible?
> > 
> > Yes, for example you could have a custom ACPI method with your device which
> > then returns this information.
> > 
> > See for example chapter 10.2.2.1 from the ACPI spec. It describes _BIF method
> > that returns some battery data to the caller.
> 
> Mika, _BIF method returns battery data/struct which is defined Table. 10-233.

Yes, it was just an example. You can have your own custom method for that,
lets say:

	BLAH()

that then returns whatever you need.

> If I want to pass some device specific data seems like I can use
> _DSM(9.14.1) method and pass custom /device specific data to the driver.

_DSM is also an option, yes.

> And I believe this data format can be anything and private to the device?
> Can you confirm?

Yes.
