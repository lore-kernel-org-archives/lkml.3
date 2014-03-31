Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaCaMGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 08:06:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:24316 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbaCaMGt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:06:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,764,1389772800"; 
   d="scan'208";a="511484915"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: 3.0 -> 3.10 regression? poweroff instead of reboot?
Thread-Topic: 3.0 -> 3.10 regression? poweroff instead of reboot?
Thread-Index: AQHPS0iuvgiDnehMNEeghRTCX5Z79Jr4hhDwgAJi2QCAADLdEA==
Date: Mon, 31 Mar 2014 12:05:20 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AFAE58E@HASMSX106.ger.corp.intel.com>
References: <20140310145530.GA27230@pcnci.linuxbox.cz>
 <20140329121550.GA5878@nik-comp.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFAD3D0@HASMSX106.ger.corp.intel.com>
 <20140331120102.GY3339@pcnci.linuxbox.cz>
In-Reply-To: <20140331120102.GY3339@pcnci.linuxbox.cz>
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


> 
> Hi Tomas,
> 
> > If this is a server platform can you please try this patch
> https://lkml.org/lkml/2014/3/25/396
> 
> tried 3.10.35 with Your patch and now I can see following in dmesg:
> 
> [  +0.000290] mei_me 0000:00:16.0: Device doesn't have valid ME Interface
> [  +0.007656] mei_me 0000:00:16.0: initialization failed.
> 
> now reboot works as expected. Once this hits ustream (if it hasn't already),
> this could go to -stable, do You agree?
> 
> thanks!
> 
I definitely asked for adding it to stable. Would you wish to add you tested-by to the patch?. 
Tomas

