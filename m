Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbaETU4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:56:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:60766 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaETU4c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:56:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,875,1392192000"; 
   d="scan'208";a="515055407"
From: "Luck, Tony" <tony.luck@intel.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>, "bp@suse.de" <bp@suse.de>,
        "gong.chen@linux.jf.intel.com" <gong.chen@linux.jf.intel.com>
Subject: RE: [PATCH 1/2] memory-failure: Send right signal code to correct
 thread
Thread-Topic: [PATCH 1/2] memory-failure: Send right signal code to correct
 thread
Thread-Index: AQHPdFSpZzlEGsh8Kkymcn7PtBlu55tJ8tvQ
Date: Tue, 20 May 2014 20:56:30 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3280FF23@ORSMSX114.amr.corp.intel.com>
References: <cover.1400607328.git.tony.luck@intel.com>
 <eb791998a8ada97b204dddf2719a359149e9ae31.1400607328.git.tony.luck@intel.com>
 <1400608486-alyqz521@n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1400608486-alyqz521@n-horiguchi@ah.jp.nec.com>
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

> Looks good to me, thank you.
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Thanks for your time reviewing this

> and I think this is worth going into stable trees.

Good point. I should dig in the git history and make one of those
fancy "Fixes: sha1 title" tags too.

-Tony
 
