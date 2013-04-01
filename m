Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab3DAMyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 08:54:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:59477 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757197Ab3DAMyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 08:54:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,387,1363158000"; 
   d="scan'208";a="221350615"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
CC: "Du, ChangbinX" <changbinx.du@intel.com>
Subject: question: will irq abort suspend process during pm is calling
 suspend() funtion of device driver?
Thread-Topic: question: will irq abort suspend process during pm is calling
 suspend() funtion of device driver?
Thread-Index: Ac4u1/3SkWQiYcJ3Srycc3Bnf5uxXA==
Date: Mon, 1 Apr 2013 12:54:06 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563AAF47F2@SHSMSX101.ccr.corp.intel.com>
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

Hello, everyone:
I am not familiar with PM module. I know if a device cannot enter suspend state, suspend will be aborted. 
But as the title descripted, Can anyone tell me if any interrupt event can make suspend process aborted?
I have analysis a piece of log and it seems the irq doesn't abort the process.

Thanks!
Du, Changbin

