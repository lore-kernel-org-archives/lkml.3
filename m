Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbaANIbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 03:31:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:43792 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaANIbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:31:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,657,1384329600"; 
   d="scan'208";a="464775998"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Munsie <imunsie@au1.ibm.com>
Subject: RE: linux-next: manual merge of the akpm-current tree with the
 char-misc tree
Thread-Topic: linux-next: manual merge of the akpm-current tree with the
 char-misc tree
Thread-Index: AQHPEORMLVGycDyIa0SJpsMaYYpbFJqD4+Fg
Date: Tue, 14 Jan 2014 08:31:26 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF42F69@HASMSX106.ger.corp.intel.com>
References: <20140114155104.0ab2772aaa909e49bc89cd61@canb.auug.org.au>
In-Reply-To: <20140114155104.0ab2772aaa909e49bc89cd61@canb.auug.org.au>
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
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Tuesday, January 14, 2014 06:51
> To: Andrew Morton; Greg KH; Arnd Bergmann
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Ian Munsie;
> Winkler, Tomas
> Subject: linux-next: manual merge of the akpm-current tree with the char-misc
> tree
> 
> Hi Andrew,
> 
> Today's linux-next merge of the akpm-current tree got a conflict in
> drivers/misc/mei/init.c between commit 33ec08263147 ("mei: revamp mei
> reset state machine") from the char-misc tree and commit dd045dab2999
> ("drivers/misc/mei: ratelimit several error messages") from the
> akpm-current tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Can we just drop this rete limit stuff, I've never asked that. 
Tomas

