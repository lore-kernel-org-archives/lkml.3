Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750956AbaAKWqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 17:46:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:57005 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbaAKWqT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 17:46:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,644,1384329600"; 
   d="scan'208";a="465256881"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>
Subject: RE: [char-misc 1/4] mei: do not run reset flow from the interrupt
 thread
Thread-Topic: [char-misc 1/4] mei: do not run reset flow from the interrupt
 thread
Thread-Index: AQHPDMirDYT8E/RffEyxtLkF2amaZZp/unsw
Date: Sat, 11 Jan 2014 22:46:14 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF40FBF@HASMSX106.ger.corp.intel.com>
References: <1389205164-13553-1-git-send-email-tomas.winkler@intel.com>
 <1389205164-13553-2-git-send-email-tomas.winkler@intel.com>
 <20140108232410.GA11300@kroah.com>
In-Reply-To: <20140108232410.GA11300@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> 
> This is a _really_ big patch for a stable kernel tree.  Are you sure
> it's needed there?  Please go read Documentation/stable_kernel_rules.txt
> again.

I understand it's big though currently I do not have significantly simpler fix for the issue, all 4 patches are needed to make the reset issue  go away.
 
Thanks
Tomas

