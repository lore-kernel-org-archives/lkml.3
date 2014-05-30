Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934463AbaE3R06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:26:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:49237 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933731AbaE3R04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:26:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,942,1392192000"; 
   d="scan'208";a="520338396"
From: "Luck, Tony" <tony.luck@intel.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, Kamil Iskra <iskra@mcs.anl.gov>,
        Borislav Petkov <bp@suse.de>, Chen Gong <gong.chen@linux.jf.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH 0/3] HWPOISON: improve memory error handling for
 multithread process
Thread-Topic: [PATCH 0/3] HWPOISON: improve memory error handling for
 multithread process
Thread-Index: AQHPe9O9WAkwlyLWbE6x5MNZMut5cZtZX+xQ
Date: Fri, 30 May 2014 17:25:39 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32823225@ORSMSX114.amr.corp.intel.com>
References: <53877e9c.8b2cdc0a.1604.ffffea43SMTPIN_ADDED_BROKEN@mx.google.com>
 <1401432670-24664-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1401432670-24664-1-git-send-email-n-horiguchi@ah.jp.nec.com>
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

> This patchset is the summary of recent discussion about memory error handling
> on multithread application. Patch 1 and 2 is for action required errors, and
> patch 3 is for action optional errors.

Naoya,

You suggested early in the discussion (when there were just two patches) that
they deserved a "Cc: stable@vger.kernel.org".  I agreed, and still think the same
way.

-Tony
