Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab3H0JOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:14:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:32508 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab3H0JOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:14:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,967,1367996400"; 
   d="scan'208";a="369063675"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "Konstantin Khlebnikov" <khlebnikov@openvz.org>
Subject: RE: [3.10][PATCH 4/4] mei: me: fix hardware reset flow
Thread-Topic: [3.10][PATCH 4/4] mei: me: fix hardware reset flow
Thread-Index: AQHOoXjP6Pl5NRmR1kOSzyTDOHPpapmnpk+AgAEgLDA=
Date: Tue, 27 Aug 2013 09:14:40 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AE9B8C7@HASMSX106.ger.corp.intel.com>
References: <1377424189-5508-1-git-send-email-tomas.winkler@intel.com>
 <1377424189-5508-5-git-send-email-tomas.winkler@intel.com>
 <20130826185503.GB15992@kroah.com>
In-Reply-To: <20130826185503.GB15992@kroah.com>
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
> On Sun, Aug 25, 2013 at 12:49:49PM +0300, Tomas Winkler wrote:
> > stable: 3.10
> > commit ff96066e3171acdea356b331163495957cb833d0 char-misc
> 
> Sorry, but I have to wait until the patch hits Linus's tree before I can accept it
> into a stable tree, you know that :(
> 
Yes I understand the process, though this patch was intended upstream I marked it 3.11 https://lkml.org/lkml/2013/7/30/117. 
So I just advice distors to pick it for their 3.10

Thanks 
Tomas.
