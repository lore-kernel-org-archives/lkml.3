Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936635Ab3DRVBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 17:01:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:21827 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936601Ab3DRVBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 17:01:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,504,1363158000"; 
   d="scan'208";a="288253907"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Bill Nottingham <notting@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mei: reseting -> resetting
Thread-Topic: [PATCH] mei: reseting -> resetting
Thread-Index: AQHOPHeiN9rQI7Cz4UGMGE0e1sA4k5jcdpNg
Date: Thu, 18 Apr 2013 21:01:25 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B01F01AA9@HASMSX106.ger.corp.intel.com>
References: <1366318791-10509-1-git-send-email-notting@redhat.com>
In-Reply-To: <1366318791-10509-1-git-send-email-notting@redhat.com>
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
> This enum leaks out to userspace via error messages, so fix the spelling.
> 
> Signed-off-by: Bill Nottingham <notting@redhat.com>
ACK
Tomas

