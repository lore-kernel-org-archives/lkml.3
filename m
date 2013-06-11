Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3FKVxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 17:53:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:1772 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756534Ab3FKVxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 17:53:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,847,1363158000"; 
   d="scan'208";a="253685170"
From: "Luck, Tony" <tony.luck@intel.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: RE: [PATCH v3 06/27] ia64, irq: Add dummy create_irq_nr()
Thread-Topic: [PATCH v3 06/27] ia64, irq: Add dummy create_irq_nr()
Thread-Index: AQHOZjQc+pMCZuzuI0C2cKr/hpi5hpkxDoOQ
Date: Tue, 11 Jun 2013 21:52:49 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F2DA79B07@ORSMSX106.amr.corp.intel.com>
References: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
	<1370644273-10495-7-git-send-email-yinghai@kernel.org>
	<20130609152259.GC2245@breakpoint.cc>
 <CAE9FiQWBrUX40Rzn_4hg7whr7B18TLxzBiJPKOZkL+JEk8-Vhw@mail.gmail.com>
In-Reply-To: <CAE9FiQWBrUX40Rzn_4hg7whr7B18TLxzBiJPKOZkL+JEk8-Vhw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Still need ia64 guys to kill create_irq() in arch/ia64.

Was there already a patch to do that? I'm afraid my eyes tend to glaze over when I
see [part 64/87: ia64 ...] and assume that its general cleanup that will flow through
with all the other parts of the patch series.  Please point me at something that you
want me to apply.

If not - then what is the recommended replacement? There seem to be a half dozen
places in arch/ia64 where create_irq() is called.

-Tony
