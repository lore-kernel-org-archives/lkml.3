Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab3BSPIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:08:05 -0500
Received: from mga03.intel.com ([143.182.124.21]:47201 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933008Ab3BSPID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:08:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,696,1355126400"; 
   d="scan'208";a="204006036"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Mika Westerberg (mika.westerberg@linux.intel.com)" 
	<mika.westerberg@linux.intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
Subject: How to populate Battery information through ACPI tables
Thread-Topic: How to populate Battery information through ACPI tables
Thread-Index: Ac4Oskyv9anm0zdmSXmuXEKAabFeBA==
Date: Tue, 19 Feb 2013 15:07:57 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD24661392@BGSMSX102.gar.corp.intel.com>
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

Hi All,

I am trying to populate battery related information through ACPI tables and do battery management through non acpi drivers.
Can you tell or point me on how to populate the ACPI tables in FW/BIOS and get them in OS? I am new to ACPI world.

Thanks,
Ram
