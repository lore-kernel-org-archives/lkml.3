Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaG2Cwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 22:52:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:16616 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbaG2Cw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 22:52:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,753,1400050800"; 
   d="scan'208";a="576893941"
From: "Brown, Aaron F" <aaron.f.brown@intel.com>
To: Ethan Zhao <ethan.zhao@oracle.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Williams, Mitch A" <mitch.a.williams@intel.com>
CC: Linux NICS <Linux-nics@isotope.jf.intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ethan.kernel@gmail.com" <ethan.kernel@gmail.com>
Subject: RE: [PATCH] ixgbe: remove useless bd_number from adapter struct
Thread-Topic: [PATCH] ixgbe: remove useless bd_number from adapter struct
Thread-Index: AQHPqjd8xZmyqU8rVUiorlIYAzrVTpu2Wvag
Date: Tue, 29 Jul 2014 02:51:25 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B73366373@ORSMSX104.amr.corp.intel.com>
References: <1406533278-27979-1-git-send-email-ethan.zhao@oracle.com>
In-Reply-To: <1406533278-27979-1-git-send-email-ethan.zhao@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Ethan Zhao
> Sent: Monday, July 28, 2014 12:41 AM
> To: Kirsher, Jeffrey T; Brandeburg, Jesse; Allan, Bruce W; Wyborny,
> Carolyn; Skidmore, Donald C; Rose, Gregory V; Duyck, Alexander H; Ronciak,
> John; Williams, Mitch A
> Cc: Linux NICS; e1000-devel@lists.sourceforge.net; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; ethan.kernel@gmail.com; Ethan Zhao
> Subject: [PATCH] ixgbe: remove useless bd_number from adapter struct
> 
> Because bd_number is not useful anymore, so remove it from adapter struct,
> or
> if keep it, we have to fix the boards driven counter bug in ixgbe_remove()
> and
> ixgbe_probe() only for trival debug purpose -- other output is enough.

Thanks Ethan, I (briefly covering for Jeff Kirsher) have added this patch and your other one ofr ixgbevf to Jeff's internal tree.
