Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab3HGLP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:15:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:8590 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247Ab3HGLPY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:15:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,832,1367996400"; 
   d="scan'208";a="358939687"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [3.10 regression] mei endless recursion
Thread-Topic: [3.10 regression] mei endless recursion
Thread-Index: AQHOknIVDR/DkW8IKUWziiido/C/RpmJkxlg
Date: Wed, 7 Aug 2013 11:15:20 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AE81EF8@HASMSX106.ger.corp.intel.com>
References: <20130806065442.GA3509@redhat.com>
In-Reply-To: <20130806065442.GA3509@redhat.com>
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



> -----Original Message-----
> From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
> Sent: Tuesday, August 06, 2013 09:55
> To: Winkler, Tomas
> Cc: linux-kernel@vger.kernel.org
> Subject: [3.10 regression] mei endless recursion
> 
> Hi
> 
> We have a bug report when system fail to boot on 3.10 . It happens due to
> problem in mei which do endless calls:
> 
> mei_reset -> mei_hbm_start_req -> mei_reset -> mei_hbm_start_req -> ...
> 
> It did not happen on 3.9.

This is the same as https://bugzilla.kernel.org/show_bug.cgi?id=60612
There is few issues with the reset but this major root cause should be fixed by this patch https://lkml.org/lkml/2013/7/17/219

Thanks
Tomas
