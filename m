Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935068AbaKNBUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:20:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:62277 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934683AbaKNBUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:20:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,381,1413270000"; 
   d="scan'208";a="622133703"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Topic: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Index: AQHP/s7+MsolZCiViEiCPzqCVeTRAJxdoOwAgACR1oD//3yvMIAAtdCAgAB2NOCAAM3pAP//e6+AgACK+ACAAAdiAIAAGwAA//+CZiU=
Date: Fri, 14 Nov 2014 01:20:43 +0000
Message-ID: <FA327E3E-10C2-4CAE-A750-812BE6CF74FB@intel.com>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141112220058.GA5295@redhat.com>
 <CALCETrWA5z7-1fiz_9N0Qi2OR5s1jCkHiynCtTD_+9taOBs-Mg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BAB4@ORSMSX114.amr.corp.intel.com>
 <CALCETrU8uyc4nu-5MBXQR0PY0rexUhPkuPRLK+gWt0gEWMDhTA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BD44@ORSMSX114.amr.corp.intel.com>
 <CALCETrUpqSpcKFRM6a1zJWebEVZxNd-5pyBW4fU19+HgcBv+2Q@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292CB9A@ORSMSX114.amr.corp.intel.com>
 <CALCETrVx7hGZodWfAoU1oee1SW7XXSn3Lr8Vs9JTOUMNtLXY4A@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292D57B@ORSMSX114.amr.corp.intel.com>
 <CALCETrVB9VQPqFb7GQyxmVEKYtPhppmZS8SewQmtre+3_su9FA@mail.gmail.com>
 <CALCETrVJE25Txr5vRKAxHpeKx9p0VJBbat44w+X4gT8qX7a4bg@mail.gmail.com>,<CALCETrVYWAOzaHqet8gS5hafvQC9prrH05qgc+v5dxSL9AF8bg@mail.gmail.com>
In-Reply-To: <CALCETrVYWAOzaHqet8gS5hafvQC9prrH05qgc+v5dxSL9AF8bg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"worst ==
MCE_AR_SEVERITY but regs->cs == 0 (i.e. in kernel)"

This can't happen. We can only declare AR severity for a user mode fault.

Sent from my iPhone

> On Nov 13, 2014, at 16:50, Andy Lutomirski <luto@amacapital.net> wrote:
> 
> worst ==
> MCE_AR_SEVERITY but regs->cs == 0 (i.e. in kernel)
