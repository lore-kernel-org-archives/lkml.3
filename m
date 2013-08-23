Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab3HWV13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:27:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:33721 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240Ab3HWV1Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:27:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,944,1367996400"; 
   d="scan'208";a="286017729"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Samuel Ortiz (sameo@linux.intel.com)" <sameo@linux.intel.com>
Subject: RE: [PATCH 13/15] MEI: convert bus code to use dev_groups
Thread-Topic: [PATCH 13/15] MEI: convert bus code to use dev_groups
Thread-Index: AQHOoEdA0IBGrmNplUCHbALYB6fxjZmjTiBg
Date: Fri, 23 Aug 2013 21:27:06 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AE8EB4A@HASMSX106.ger.corp.intel.com>
References: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
 <1377293081-10957-13-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1377293081-10957-13-git-send-email-gregkh@linuxfoundation.org>
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
> The dev_attrs field of struct bus_type is going away soon, dev_groups should
> be used instead.  This converts the MEI bus code to use the correct field.
> 
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

ACK
+ CC: Samuel.
Thanks
Tomas

