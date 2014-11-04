Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaKDHVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:21:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:31227 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbaKDHU7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:20:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,312,1413270000"; 
   d="scan'208";a="626079526"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>
Subject: RE: [char-misc-next V2] mei: nfc: clean nfc internal struct on host
 exit
Thread-Topic: [char-misc-next V2] mei: nfc: clean nfc internal struct on
 host exit
Thread-Index: AQHP98HTqHHhoJfXIkKMIdhTwnuG+ZxQD45Q
Date: Tue, 4 Nov 2014 07:20:55 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1C493238@HASMSX106.ger.corp.intel.com>
References: <1412667290-27964-1-git-send-email-tomas.winkler@intel.com>
 <20141103235630.GA31313@kroah.com>
In-Reply-To: <20141103235630.GA31313@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Stable: 3.15+
> 
> Please read Documentation/stable_kernel_rules.txt for how to do this
> properly.

Oops, this is my internal tracking it should be replaced with proper cc to stable, need to fix my scripts. 

> Please resend, after really verifying this does need to go to the stable
> trees...

Ok
Tomas

