Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaDOJBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:01:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:28943 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbaDOJBW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:01:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="521016338"
From: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alan Cox <alan@linux.intel.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] pwm_lpss: Add support for PCI devices
Thread-Topic: [PATCH] pwm_lpss: Add support for PCI devices
Thread-Index: AQHPVhP1bci2OBKO+kqYMQwhKouSaZsO1QwAgAGJ3AD//+5ugIACFsLA
Date: Tue, 15 Apr 2014 08:59:31 +0000
Message-ID: <604BF5F4C5D71041942BC7E84ED659EA01570E4F@PGSMSX103.gar.corp.intel.com>
References: <1397311131-13371-1-git-send-email-chiau.ee.chew@intel.com>
 <534A67B8.80600@linux.intel.com>
 <604BF5F4C5D71041942BC7E84ED659EA01570A7A@PGSMSX103.gar.corp.intel.com>
 <20140414085911.GL19349@intel.com>
In-Reply-To: <20140414085911.GL19349@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Apr 14, 2014 at 02:05:25AM +0000, Chew, Chiau Ee wrote:
> > > >  MODULE_DESCRIPTION("PWM driver for Intel LPSS");
> > > >MODULE_AUTHOR("Mika  Westerberg
> > > ><mika.westerberg@linux.intel.com>");
> > > >  MODULE_LICENSE("GPL v2");
> > > >  MODULE_ALIAS("platform:pwm-lpss");
> > >
> > > Looks a good idea to combine pci and acpi driver together.
> > > Since pci driver is added, here the alias need to be refined.
> > > Others look good.
> > >
> > > Thanks,
> > > -Aubrey
> >
> > Ok. I will change it to MODULE_ALIAS("pci/platform:pwm-lpss");
> 
> Hmm, does that really work like that?
> 
> For PCI and ACPI you already have tables with MODULE_DEVICE_TABLE().
> 
> For pure platform driver (which is probably not going to be used) you nede to
> have MODULE_ALIAS() if you want modprobe to load it automagically.

Ok, looks like MODULE_ALIAS() is a redundant. I will remove it.
