Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762975Ab3JQVfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:35:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:62021 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762379Ab3JQVfF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:35:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,517,1378882800"; 
   d="scan'208";a="418623684"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Borislav Petkov <bp@alien8.de>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Aristeu Rozanski Filho" <arozansk@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>
Subject: RE: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
Thread-Topic: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
Thread-Index: AQHOxk3GSPFKevrviUSFtROVbDKwIZn2dzGAgAABsoCAAAhygIAAePIAgACPTgCAABYRgIAAAd+AgAAUkgCAABvl0IABX7yAgABCm+A=
Date: Thu, 17 Oct 2013 21:35:02 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D33F77@ORSMSX106.amr.corp.intel.com>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-9-git-send-email-gong.chen@linux.intel.com>
 <20131015165435.GA2777@naverao1-tp.ibm.com> <20131015170039.GF7908@pd.tnic>
 <525D7BCD.7080303@linux.vnet.ibm.com>
 <20131015214346.68718bcd.m.chehab@samsung.com>
 <20131016091640.GA13608@pd.tnic>
 <20131016073539.5a48f65e.m.chehab@samsung.com>
 <20131016104221.GC13608@pd.tnic> <20131016085558.19fe143a@samsung.com>
 <3908561D78D1C84285E8C5FCA982C28F31D31C65@ORSMSX106.amr.corp.intel.com>
 <20131017073443.675e97f2@samsung.com>
In-Reply-To: <20131017073443.675e97f2@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There's also a third case: mirrored memories.

Mirrors are currently something of a mess - we don't get any useful notification when one breaks.
We do need to fix this - and make sure reporting is properly integrated with everything else - I'm
just not sure how to do this.

-Tony
