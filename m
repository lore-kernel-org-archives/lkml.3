Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbaCUMYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 08:24:32 -0400
Received: from smtp2out.l-3com.com ([166.20.51.112]:58432 "EHLO
	smtp2out.l-3com.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbaCUMYa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 08:24:30 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Mar 2014 08:24:30 EDT
X-filenames: 
X-filesizes: None
X-filetypes: 
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,703,1389744000"; 
   d="scan'208";a="226538693"
X-IronPort-AV: E=Sophos;i="4.97,703,1389765600"; 
   d="scan'208";a="5237332"
From: <jimmie.davis@l-3com.com>
To: <umgwanakikbuti@gmail.com>, <artem_fetishev@epam.com>
CC: <peterz@infradead.org>, <kosaki.motohiro@jp.fujitsu.com>,
        <linux-kernel@vger.kernel.org>
Subject: RE: Bug 71331 - mlock yields processor to lower priority process
Thread-Topic: Bug 71331 - mlock yields processor to lower priority process
Thread-Index: AQHPRNwZPC5PRgt+P0GtAN8yDFKRX5rrmJkA///XPHs=
Date: Fri, 21 Mar 2014 12:18:45 +0000
Message-ID: <FFF95760268D324AB6DD9426E83C8DF70B2E5870@ARLEXCHMBX01.lst.link.l-3com.com>
References: <20140321200248.GB6264@owamsq.epam.com>,<1395393822.6030.59.camel@marge.simpson.net>
In-Reply-To: <1395393822.6030.59.camel@marge.simpson.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [130.210.49.246]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>How is that different from any other time a task has to yield the CPU
>for a bit?  While your high priority task is blocked for whatever
>reason, a lower priority task gets to use the CPU.

 
As the submitter of the bug, let me give you my perspective.  SCHED_FIFO means run my task until it blocks or a higher priority task pre-empts it.  Period.

mlock() doesn't block.  check the man page.

Any other way and you are not able to use priority based scheduling.   
 

--bud davis




 

