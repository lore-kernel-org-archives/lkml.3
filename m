Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab3CZDMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 23:12:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:25574 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759289Ab3CZDMu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 23:12:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,909,1355126400"; 
   d="scan'208";a="311865346"
From: "Brown, Len" <len.brown@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>, Len Brown <lenb@kernel.org>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: RE: [PATCH 09/16] ia64 idle: delete pm_idle
Thread-Topic: [PATCH 09/16] ia64 idle: delete pm_idle
Thread-Index: AQHOB1OvbyP85kEfnkuHgKR7z07XTJiEsEmAgDLgfzA=
Date: Tue, 26 Mar 2013 03:12:35 +0000
Message-ID: <1A7043D5F58CCB44A599DFD55ED4C9482976B321@FMSMSX108.amr.corp.intel.com>
References: <1360475903-30007-1-git-send-email-lenb@kernel.org>
 <7dc2a692a27e9c3da86acf150c4a89024e48bd05.1360475150.git.len.brown@intel.com>
 <5125F3D3.6040309@metafoo.de>
In-Reply-To: <5125F3D3.6040309@metafoo.de>
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

> > -			idle = pm_idle;
> >  			if (!idle)
> 
> Hm, if I'm not mistaken idle will uninitialized at this point, so this
> could quite likely lead to a crash.


thanks,
will fix.

-Len

