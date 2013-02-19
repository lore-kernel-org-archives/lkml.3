Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934190Ab3BSTjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:39:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:21385 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933049Ab3BSTjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:39:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,697,1355126400"; 
   d="scan'208";a="293198110"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: "Westerberg, Mika" <mika.westerberg@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>
Subject: RE: How to populate Battery information through ACPI tables
Thread-Topic: How to populate Battery information through ACPI tables
Thread-Index: Ac4Oskyv9anm0zdmSXmuXEKAabFeBP//qGcA//+HEBCAAKCfAP//pGJQgABhtwD//6AxsAANLFUA//+g47D//5UmAP/+yTbw
Date: Tue, 19 Feb 2013 19:39:01 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD246620C6@BGSMSX102.gar.corp.intel.com>
References: <D854C92F57B1B347B57E531E78D05EAD24661392@BGSMSX102.gar.corp.intel.com>
 <20130219152008.GG2439@intel.com>
 <D854C92F57B1B347B57E531E78D05EAD2466175B@BGSMSX102.gar.corp.intel.com>
 <20130219174210.GH2439@intel.com>
 <D854C92F57B1B347B57E531E78D05EAD2466187B@BGSMSX102.gar.corp.intel.com>
 <20130219180400.GJ2439@intel.com>
 <D854C92F57B1B347B57E531E78D05EAD24661A83@BGSMSX102.gar.corp.intel.com>
 <20130219183816.GK2439@intel.com>
 <D854C92F57B1B347B57E531E78D05EAD24661DB3@BGSMSX102.gar.corp.intel.com>
 <20130219192016.GL2439@intel.com>
In-Reply-To: <20130219192016.GL2439@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Mika, _BIF method returns battery data/struct which is defined Table. 10-233.
> 
> Yes, it was just an example. You can have your own custom method for that, lets
> say:
> 
> 	BLAH()
> 
> that then returns whatever you need.
> 
> > If I want to pass some device specific data seems like I can use
> > _DSM(9.14.1) method and pass custom /device specific data to the driver.
> 
> _DSM is also an option, yes.
> 
> > And I believe this data format can be anything and private to the device?
> > Can you confirm?
> 
> Yes.

Gr8. Appreciate your prompt response and help.
Have nice day :-)
