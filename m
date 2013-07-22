Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3GVFky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 01:40:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:52525 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984Ab3GVFkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 01:40:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,717,1367996400"; 
   d="scan'208";a="271419316"
From: "Hefty, Sean" <sean.hefty@intel.com>
To: Michel Lespinasse <walken@google.com>, LKML <linux-kernel@vger.kernel.org>
CC: "linux-rdma (linux-rdma@vger.kernel.org)" 
	<linux-rdma@vger.kernel.org>
Subject: RE: infiniband build warning
Thread-Topic: infiniband build warning
Thread-Index: AQHOhnwbSFtlBjl+NkWjktkLMgEXOJlwLnMQ
Date: Mon, 22 Jul 2013 05:40:49 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373805BA08A@ORSMSX109.amr.corp.intel.com>
References: <20130722013758.GA14337@google.com>
In-Reply-To: <20130722013758.GA14337@google.com>
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

> I am seeing build warnings in drivers/infiniband/core/cma.c starting with
> v3.11-rc1. These can be reproduced with gcc 4.6.3.
> 
> Would you consider applying the following fix ?

A patch to fix this was submitted to the linux-rdma list last week.	  Thanks.

- Sean
