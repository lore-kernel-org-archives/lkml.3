Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750981Ab3FWHsL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 03:48:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:1706 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab3FWHsK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 03:48:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,922,1363158000"; 
   d="scan'208";a="258890919"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Charles Anthony <charles.unix.pro@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Minor patch for drivers/misc/mei/pci-me.c: Delete stray
 dev_err() calls.
Thread-Topic: [PATCH] Minor patch for drivers/misc/mei/pci-me.c: Delete
 stray dev_err() calls.
Thread-Index: AQHObslOS4AhF9cI20iavAaKC+zOGZlC7ibA
Date: Sun, 23 Jun 2013 07:48:05 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B028D82E9@HASMSX106.ger.corp.intel.com>
References: <CANV78LQqr8sd3JXBCDGKVY8KNWY67gWRxZRV6uAGdWND7fWL6g@mail.gmail.com>
In-Reply-To: <CANV78LQqr8sd3JXBCDGKVY8KNWY67gWRxZRV6uAGdWND7fWL6g@mail.gmail.com>
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
> The pci-me.c code contains 2 dev_err() calls which are apparently left over
> from debugging; they do not represent actual error conditions.
> They do produce messages in a "quiet" kernel, and add ERROR entries to the
> logger.
> 
> Signed-off-by: "charles anthony" <charles.unix.pro@gmail.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>

