Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762083Ab3JPUf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:35:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:20438 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761650Ab3JPUf4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:35:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="308738167"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Borislav Petkov <bp@alien8.de>
CC: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Aristeu Rozanski Filho <arozansk@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>
Subject: RE: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
Thread-Topic: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
Thread-Index: AQHOxk3GSPFKevrviUSFtROVbDKwIZn2dzGAgAABsoCAAAhygIAAePIAgACPTgCAABYRgIAAMPIQ
Date: Wed, 16 Oct 2013 20:35:32 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D31C28@ORSMSX106.amr.corp.intel.com>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-9-git-send-email-gong.chen@linux.intel.com>
 <20131015165435.GA2777@naverao1-tp.ibm.com> <20131015170039.GF7908@pd.tnic>
 <525D7BCD.7080303@linux.vnet.ibm.com>
 <20131015214346.68718bcd.m.chehab@samsung.com>
 <20131016091640.GA13608@pd.tnic>
 <20131016073539.5a48f65e.m.chehab@samsung.com>
In-Reply-To: <20131016073539.5a48f65e.m.chehab@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are there any changes with regards to that, like some enforcement policy
> for BIOS manufacturers to make it right?

I am using a cricket bat to beat BIOS teams that implement eMCA to make
sure they get the labels in SMBIOS right. :-)

It's a non-trivial implementation effort to get all the decoding done for
the eMCA log.  It's typically a simple string change to fix the SMBIOS
table ... there has been some resistance - but so far I have been victorious.
Wish me luck as I'm about to engage with another team.

-Tony
