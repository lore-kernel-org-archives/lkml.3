Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159AbaKDAy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:54:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:52493 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbaKDAy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:54:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,310,1413270000"; 
   d="scan'208";a="625916523"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
        "Tan, Raymond" <raymond.tan@intel.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Subject: RE: [PATCH 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000
 I2C-GPIO MFD Driver
Thread-Topic: [PATCH 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000
 I2C-GPIO MFD Driver
Thread-Index: AQHP9zm83r/nWKJ6t0a9/XEnzc824JxOLysAgAFydyCAAAKX4A==
Date: Tue, 4 Nov 2014 00:51:55 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E9AB082@SHSMSX101.ccr.corp.intel.com>
References: <1415000344-23575-1-git-send-email-raymond.tan@intel.com>
 <1415000344-23575-2-git-send-email-raymond.tan@intel.com>
 <54575A68.7060009@nexus-software.ie> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Chen, Alvin
> Sent: Tuesday, November 4, 2014 8:46 AM
> To: 'Bryan O'Donoghue'; Tan, Raymond; Lee Jones; Samuel Ortiz
> Cc: linux-kernel@vger.kernel.org; Shevchenko, Andriy
> Subject: RE: [PATCH 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000
> I2C-GPIO MFD Driver
> 
> >
> > On 03/11/14 07:39, Raymond Tan wrote:
> > > +	pdata->properties->irq	= pdev->irq;
> > > +	pdata->properties->irq_shared	= true;
> >
> > OK I see it.
> >
> > Thanks.
> >
> > My question is. How extensively have edge triggered interrupts been
> > tested on the GPIO block ?
> >
> > The BSP reference code is quite explicit about not missing edge interrupts.
> >
> > Have you tested GPIO input in edge mode ?
> We indeed test edge mode. Now all are moved to gpio-dwapb module which
> has been accepted by maintainer.
> The BSP code doesn't meet the requirement of upstream, so we totally
> re-implement this feature in gpio-dwapb.
> This patch only passes the necessary parameters and registers the platform
> devices.
> 
> 
Just double check, the support of Quark designware GPIO has been in 3.18-rc2.

