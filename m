Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbbA2Nr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:47:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:36875 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280AbbA2NrY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:47:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,486,1418112000"; 
   d="scan'208";a="658610452"
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
Thread-Index: AQHQOylqnLZVjTv+WEq44p1GA6waZpzWMk6AgAAoNgCAAAEsAIAAwdXQ
Date: Thu, 29 Jan 2015 13:47:18 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B7327158BE@PGSMSX105.gar.corp.intel.com>
References: <1422470186-7860-1-git-send-email-pure.logic@nexus-software.ie>
	<1422470186-7860-2-git-send-email-pure.logic@nexus-software.ie>
	<20150129074411.GA4817@gmail.com>
 <CAHp75Vfff-C++LWyyK+FWLnot=jO4kQvbDaN9hJ2_VrhG8n2Qg@mail.gmail.com>
 <54CA0782.8000807@nexus-software.ie>
In-Reply-To: <54CA0782.8000807@nexus-software.ie>
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

Bryan,

Once you have the next revision ready, I would like to test it on my end across both Galileo Gen v1 & v2. 

Cheers,
BL  

>-----Original Message-----
>From: Bryan O'Donoghue [mailto:pure.logic@nexus-software.ie]
>Sent: Thursday, January 29, 2015 6:12 PM
>To: Andy Shevchenko; Ingo Molnar
>Cc: Thomas Gleixner; Ingo Molnar; H. Peter Anvin; x86@kernel.org;
>dvhart@infradead.org; Ong, Boon Leong; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
>
>On 29/01/15 10:08, Andy Shevchenko wrote:
>> On Thu, Jan 29, 2015 at 9:44 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>> * Bryan O'Donoghue <pure.logic@nexus-software.ie> wrote:
>>
>> []
>>
>>> In any case, I don't see any major problems with this code, so if
>>> it's fixed it could go into v3.20.
>>
>> Brian, it would be really nice to have it in 3.20 since we have
>> several drivers already in upstream or be ready for 3.20.
>> It would be then first upstream kernel with minimal Quark support.
>
>NP lads - I'll get a patch out today

