Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934800Ab3BTJlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:41:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:64424 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934684Ab3BTJln convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:41:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,699,1355126400"; 
   d="scan'208";a="289477020"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: "Mika Westerberg (mika.westerberg@linux.intel.com)" 
	<mika.westerberg@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>, "Brown, Len" <len.brown@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: Linux ACPI DSDT table editing tools
Thread-Topic: Linux ACPI DSDT table editing tools
Thread-Index: Ac4PPJRi/+iM1RuJTM2QvyhQ+qOZKv//xJ+A//+g6BA=
Date: Wed, 20 Feb 2013 09:41:38 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD24663A5F@BGSMSX102.gar.corp.intel.com>
References: <D854C92F57B1B347B57E531E78D05EAD24663596@BGSMSX102.gar.corp.intel.com>
 <20130220093059.GP2439@intel.com>
In-Reply-To: <20130220093059.GP2439@intel.com>
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

> > I am looking for tools(Linux or w*****s) for editing ACPI tables.
> > Can you advise me some good tools. Also I would like to know how BIOS
> > engineers populate the ACPI tables? Which tools they use?
> 
> Dunno about the BIOS engineers but I use tools from acpica (acpica.org).
> There is ASL (dis)assembler and other useful tools in that.
> 
> In addition there is tools/power/acpi/acpidump.c in the kernel source tree which
> is extremely useful.

Thanks again Mika :-)
