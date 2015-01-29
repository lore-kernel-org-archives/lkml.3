Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbbA2PdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:33:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:57797 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787AbbA2PdA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:33:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,486,1418112000"; 
   d="scan'208";a="669751459"
From: "Ong, Boon Leong" <boon.leong.ong@intel.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "dvhart@infradead.org" <dvhart@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: RE: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
Thread-Topic: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
Thread-Index: AQHQOylqnLZVjTv+WEq44p1GA6waZpzWMk6AgAAoNgCAAAEsAIAAwdXQ//+UzICAAIb+4A==
Date: Thu, 29 Jan 2015 15:32:55 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B732715B43@PGSMSX105.gar.corp.intel.com>
References: <1422470186-7860-1-git-send-email-pure.logic@nexus-software.ie>
	<1422470186-7860-2-git-send-email-pure.logic@nexus-software.ie>
	<20150129074411.GA4817@gmail.com>
 <CAHp75Vfff-C++LWyyK+FWLnot=jO4kQvbDaN9hJ2_VrhG8n2Qg@mail.gmail.com>
 <54CA0782.8000807@nexus-software.ie>
 <AF233D1473C1364ABD51D28909A1B1B7327158BE@PGSMSX105.gar.corp.intel.com>
 <54CA502D.9030307@nexus-software.ie>
In-Reply-To: <54CA502D.9030307@nexus-software.ie>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Bryan O'Donoghue [mailto:pure.logic@nexus-software.ie]
>Sent: Thursday, January 29, 2015 11:22 PM
>To: Ong, Boon Leong
>Cc: Thomas Gleixner; Ingo Molnar; H. Peter Anvin; x86@kernel.org;
>dvhart@infradead.org; linux-kernel@vger.kernel.org; Andy Shevchenko; Ingo
>Molnar
>Subject: Re: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
>
>On 29/01/15 13:47, Ong, Boon Leong wrote:
>> Bryan,
>>
>> Once you have the next revision ready, I would like to test it on my end across
>both Galileo Gen v1 & v2.
>>
>> Cheers,
>> BL
>
>Andy/BL - thanks for taking the time to test.
>
>I may end up dropping the imr_del_range() tests based on index as a result of
>changing the external interface as suggested by Ingo.
It would be nice to have two variants (1) index based & (2) address based. 

>
>If you guys have a clear preference to keep those tests shout now and I'll re-
>merge the imr_selftest code into the main chunk of IMR code.
Ok, once you have that ready, I will re-run the test on my end. 

>
>--
>BOD

