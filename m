Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab3KKWBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 17:01:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:38245 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab3KKWB1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 17:01:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,680,1378882800"; 
   d="scan'208";a="431615427"
From: "Dixit, Ashutosh" <ashutosh.dixit@intel.com>
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
CC: "Anvin, H Peter" <h.peter.anvin@intel.com>,
        "Dutt, Sudeep" <sudeep.dutt@intel.com>,
        "Yokoyama, Caz" <caz.yokoyama@intel.com>,
        "Chandramouli, Dasaratharaman" 
	<dasaratharaman.chandramouli@intel.com>,
        "Rao, Nikhil" <nikhil.rao@intel.com>,
        "Kharche, Harshavardhan R" <harshavardhan.r.kharche@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] checkpatch: Don't require kernel style __attribute__
 shortcuts in uapi paths
Thread-Topic: [PATCH] checkpatch: Don't require kernel style __attribute__
 shortcuts in uapi paths
Thread-Index: AQHO3l+RIm7575CVbUa4le511mDsu5oglZ3Q
Date: Mon, 11 Nov 2013 22:01:10 +0000
Message-ID: <6DC2528F945B4149AB6566DFB5F22ED38AAA1DC8@ORSMSX109.amr.corp.intel.com>
References: <527D5646.9010005@intel.com>
	 <6DC2528F945B4149AB6566DFB5F22ED38AAA18B7@ORSMSX109.amr.corp.intel.com>
 <1384120524.3081.18.camel@joe-AO722>
In-Reply-To: <1384120524.3081.18.camel@joe-AO722>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Sunday, November 10, 2013 1:55 PM
> Subject: [PATCH] checkpatch: Don't require kernel style __attribute__ shortcuts
> in uapi paths
> 
> Avoid proscribing kernel styled shortcuts for
> gcc extensions of __attribute__((foo)) in the
> uapi include paths.
 
Thanks Joe. This works for us nicely.

