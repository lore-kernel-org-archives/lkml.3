Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab3KFWcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 17:32:15 -0500
Received: from mga14.intel.com ([143.182.124.37]:30176 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab3KFWcO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 17:32:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="385682266"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Ingo Molnar <mingo@kernel.org>
CC: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86/apic: Disable I/O APIC before shutdown local APIC
Thread-Topic: [PATCH] x86/apic: Disable I/O APIC before shutdown local APIC
Thread-Index: AQHO0XEQ1goUKaaSDkuV7+Ij2zXrD5oY1zMw
Date: Wed, 6 Nov 2013 22:32:12 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712205A58164A@ORSMSX106.amr.corp.intel.com>
References: <1382578212-4677-1-git-send-email-fenghua.yu@intel.com>
 <20131025105742.GA5485@gmail.com>
In-Reply-To: <20131025105742.GA5485@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ingo Molnar [mailto:mingo.kernel.org@gmail.com] wrote:
> Friday, October 25, 2013 3:58 AM
> 
> * Fenghua Yu <fenghua.yu@intel.com> wrote:
> 
> > From: Fenghua Yu <fenghua.yu@intel.com>
> >
> > In reboot and crash path, when shutdown local APIC, I/O APIC is still
> active.
> > This may cause issues because external interrupts can still come in
> and
> > disturb local APIC during shutdown process. To quiet external
> interrupts,
> > disable I/O APIC before shutdown local APIC.
> 
> What specific 'issues' were observed, on what kind of systems?
> 

This patch is a workaround for a to-be-published erratum; the erratum
will be published in a few weeks.

Thanks.

-Fenghua
