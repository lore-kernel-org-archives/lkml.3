Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaHTAqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 20:46:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:60657 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbaHTAqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 20:46:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,898,1400050800"; 
   d="scan'208";a="560844624"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH] USB: pch_udc: USB gadget device support for Intel Quark
 X1000
Thread-Topic: [PATCH] USB: pch_udc: USB gadget device support for Intel
 Quark X1000
Thread-Index: AQHPu7jWizq2pocvXku+0qYGlydmoJvYqDsQ
Date: Wed, 20 Aug 2014 00:46:33 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E97D609@SHSMSX101.ccr.corp.intel.com>
References: <1407172974-22485-1-git-send-email-alvin.chen@intel.com>
 <20140819141534.GC16085@saruman.home>
In-Reply-To: <20140819141534.GC16085@saruman.home>
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


> Hi,
> 
> On Mon, Aug 04, 2014 at 10:22:54AM -0700, Chen, Alvin wrote:
> > From: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> >
> > This patch is to enable the USB gadget device for Intel Quark X1000
> >
> > Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> > Signed-off-by: Bing Niu <bing.niu@intel.com>
> > Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
> 
> Can someone confirm to me this is not another incarnation of chipidea ?

No, this is not another incarnation of chipidea. And its cover letter is as following:

On Mon, Aug 04, 2014 at 11:00:07AM -0700, Chen, Alvin wrote:
> From: "Alvin (Weike) Chen" <alvin.chen@intel.com>
> 
> Hi,
> Intel Quark X1000 consists of one USB gadget device which can be PCI enumerated. 
> pch_udc layer doesn't support it. Thus, we add support for Intel Quark 
> X1000 USB gadget device as well.
