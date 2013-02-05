Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab3BEAHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 19:07:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:32270 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab3BEAHL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 19:07:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,602,1355126400"; 
   d="scan'208";a="282757644"
From: "Hefty, Sean" <sean.hefty@intel.com>
To: Tejun Heo <tj@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "skinsbursky@parallels.com" <skinsbursky@parallels.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>, Roland Dreier <roland@kernel.org>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH v2 22/62] infiniband/core: convert to idr_alloc()
Thread-Topic: [PATCH v2 22/62] infiniband/core: convert to idr_alloc()
Thread-Index: AQHOAvbabJRvMdCaGESe6kAlS1ptrphqXTog
Date: Tue, 5 Feb 2013 00:07:09 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237357D43183@ORSMSX101.amr.corp.intel.com>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <1359854463-2538-23-git-send-email-tj@kernel.org>
 <20130204164355.GD27963@mtj.dyndns.org>
In-Reply-To: <20130204164355.GD27963@mtj.dyndns.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Sean Hefty <sean.hefty@intel.com>
