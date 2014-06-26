Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677AbaFZBSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 21:18:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:42867 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757640AbaFZBSD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 21:18:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,548,1400050800"; 
   d="scan'208";a="563569888"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: David Laight <David.Laight@ACULAB.COM>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Stern <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Thread-Topic: [PATCH] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Thread-Index: AQHPj6/C5BxdJArRXUevrLYTW6T4oZuBj0uwgAAC7LCAAQbhQA==
Date: Thu, 26 Jun 2014 01:17:28 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E9472BE@SHSMSX101.ccr.corp.intel.com>
References: <1403625103-28078-1-git-send-email-alvin.chen@intel.com>
 <1403625103-28078-2-git-send-email-alvin.chen@intel.com>
 <20140624132527.GB1215@kroah.com>
 <4656BEB6164FC34F8171C6538F1A595B2E946EF1@SHSMSX101.ccr.corp.intel.com>
 <063D6719AE5E284EB5DD2968C1650D6D17264B1D@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D17264B1D@AcuExch.aculab.com>
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

> >
> > OK, I will change ' usb_is_intel_qrk ' to ' usb_is_intel_quark'.
> 
> Or even usb_is_intel_quark_x1000() ?
> 
OK, I will change the function name as your suggestion to make it more specific.

> 	David
> 
> 

