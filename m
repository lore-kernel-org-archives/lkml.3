Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3BQHcH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 02:32:07 -0500
Received: from mga14.intel.com ([143.182.124.37]:18701 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526Ab3BQHcE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 02:32:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,682,1355126400"; 
   d="scan'208";a="203215504"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Len Brown <lenb@kernel.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Krogerus, Heikki" <heikki.krogerus@intel.com>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: RE: linux-next: manual merge of the acpi tree with the pm tree
Thread-Topic: linux-next: manual merge of the acpi tree with the pm tree
Thread-Index: AQHOB/tjFlInWkucOEq+/X12FYrI7ph0yn0AgAGAfQCAB0ReQA==
Date: Sun, 17 Feb 2013 07:31:57 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88C06087@SHSMSX101.ccr.corp.intel.com>
References: <20130211125856.64b216a03dd18218c4627635@canb.auug.org.au>
	<51197FEE.9070606@kernel.org>
 <20130213093014.b6d0a21e1299823763ba3113@canb.auug.org.au>
In-Reply-To: <20130213093014.b6d0a21e1299823763ba3113@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Len,
> 
> On Mon, 11 Feb 2013 18:34:06 -0500 Len Brown <lenb@kernel.org> wrote:
> >
> > BTW. Rafael's "pm" tree now carries the ACPI patch stream, so it is
> > probably a mis-representation to call my tree the "acpi" tree.
> > My tree is primarily focused on the "idle" part of pm these days.
> 
> OK, I have renamed your tree to "idle".

Thanks for fixing the conflicts.

The new ACPICA release contains a patch renaming the PM_TIMER_FREQUENCY macro.
A further CA release patch cleans up the repo (pm/linux-next) where the release patch set based on.
The conflicts would happen if other repos contained new codes using the old macro definition.

Thanks
-Lv
