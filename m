Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3EUPBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 11:01:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:22967 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab3EUPBe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 11:01:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,714,1363158000"; 
   d="scan'208";a="337655313"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: RE: [PATCH] [3.10] mei: bus: Reset event_cb when disabling a device
Thread-Topic: [PATCH] [3.10] mei: bus: Reset event_cb when disabling a device
Thread-Index: AQHOVis7CWvG47qD5UG7R/nagjEs65kPu5zw
Date: Tue, 21 May 2013 15:01:27 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B01F2E489@HASMSX106.ger.corp.intel.com>
References: <20130521135817.GE4589@zurbaran>
In-Reply-To: <20130521135817.GE4589@zurbaran>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Samuel Ortiz [mailto:sameo@linux.intel.com]
> Sent: Tuesday, May 21, 2013 16:58
> To: Winkler, Tomas
> Cc: linux-kernel
> Subject: [PATCH] [3.10] mei: bus: Reset event_cb when disabling a device
> 
> After cancelling all reads from the disable hook, we need to reset the
> event_cb pointer as well or else we won't be able to set a new one up when
> re-enabling the device.
> 
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Acked.

