Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaILJZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:25:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:11586 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbaILJZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:25:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,511,1406617200"; 
   d="scan'208";a="477084701"
Message-ID: <1410513950.7023.41.camel@linux.intel.com>
Subject: Re: Ask help about pre_init_apic_IRQ0()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Date: Fri, 12 Sep 2014 12:25:50 +0300
In-Reply-To: <alpine.DEB.2.10.1409121020290.4178@nanos>
References: <54116106.5090904@linux.intel.com>
	 <alpine.DEB.2.10.1409111225380.4178@nanos>
	 <1410444181.7023.25.camel@linux.intel.com>
	 <alpine.DEB.2.10.1409111610430.4178@nanos>
	 <1410448503.7023.27.camel@linux.intel.com>
	 <alpine.DEB.2.10.1409112354501.4178@nanos>
	 <1410509968.7023.33.camel@linux.intel.com>
	 <alpine.DEB.2.10.1409121020290.4178@nanos>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-12 at 10:26 +0200, Thomas Gleixner wrote:
> Thanks for providing the data! I'll queue a removal of this mess.

You are welcome!

Just in case:
http://www.spinics.net/lists/platform-driver-x86/msg02948.html



-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

