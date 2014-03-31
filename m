Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbaCaRmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:42:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:53415 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbaCaRmG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:42:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,766,1389772800"; 
   d="scan'208";a="503722321"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: Monam Agarwal <monamagarwal123@gmail.com>,
        infinipath <infinipath@intel.com>,
        "roland@kernel.org" <roland@kernel.org>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] drivers/infiniband: Use RCU_INIT_POINTER(x, NULL) in
 hw/qib/qib_keys.c
Thread-Topic: [PATCH] drivers/infiniband: Use RCU_INIT_POINTER(x, NULL) in
 hw/qib/qib_keys.c
Thread-Index: AQHPRg6RzCetS2XYI0ab66aFw7nr/pr7hGuA
Date: Mon, 31 Mar 2014 17:41:06 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2122392C@FMSMSX107.amr.corp.intel.com>
References: <1395520599-3411-1-git-send-email-monamagarwal123@gmail.com>
In-Reply-To: <1395520599-3411-1-git-send-email-monamagarwal123@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: [PATCH] drivers/infiniband: Use RCU_INIT_POINTER(x, NULL) in
> hw/qib/qib_keys.c
> 
> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>

Thanks for the patch!

Acked-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
