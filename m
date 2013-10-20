Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138Ab3JTGBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 02:01:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:47473 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab3JTGBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 02:01:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,532,1378882800"; 
   d="scan'208";a="377206301"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] iwlwifi: remove duplicate includes
Thread-Topic: [PATCH] iwlwifi: remove duplicate includes
Thread-Index: AQHOzVHVeHype0Fitk++ZHQaFlSKCJn9GPWQ
Date: Sun, 20 Oct 2013 06:01:42 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301DDAABA@HASMSX103.ger.corp.intel.com>
References: <1382245260-19065-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1382245260-19065-1-git-send-email-michael.opdenacker@free-electrons.com>
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

> Subject: [PATCH] iwlwifi: remove duplicate includes
> 
> Reported by "make includecheck"
> 
> Tested that the corresponding sources still compile well on x86
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-
> electrons.com>
> ---

Picked up. Thanks.
