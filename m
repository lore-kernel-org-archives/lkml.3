Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab3LEN1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:27:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:42537 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab3LEN1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:27:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,833,1378882800"; 
   d="scan'208";a="419878326"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH] x86/apic: Justification for disabling IO APIC before
 Local APIC
Thread-Topic: [PATCH] x86/apic: Justification for disabling IO APIC before
 Local APIC
Thread-Index: AQHO8U43V739YbLc40WYv3wONEawOppF0tCA///FOVA=
Date: Thu, 5 Dec 2013 13:27:05 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712205A595596@ORSMSX106.amr.corp.intel.com>
References: <1386202069-51515-1-git-send-email-fenghua.yu@intel.com>
 <20131205085451.GA13377@gmail.com>
In-Reply-To: <20131205085451.GA13377@gmail.com>
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

> From: Ingo Molnar [mailto:mingo.kernel.org@gmail.com] On Behalf Of Ingo
> Molnar
> Sent: Thursday, December 05, 2013 12:55 AM
> 
> 
> * Fenghua Yu <fenghua.yu@intel.com> wrote:
> 
> > From: Fenghua Yu <fenghua.yu@intel.com>
> >
> > Since erratum AVR31 in "Intel Atom Processor C2000 Product Family
> > Specification Update" is published, I add a justification comment for
> > disabling IO APIC before Local APIC (commit 522e6646).
> >
> 
> Looks good to me, except that patch titles should start with verbs,
> i.e. something like:
> 
>   x86/apic/doc: Add justification for disabling IO APIC before Local
> APIC
> 
> Which makes for a much more fluid reading of shortlogs etc.
> 
> Unless you sentences without verbs.
>           ^-------------------------------------------like
> 
> ;-)
> 
> Thanks,
> 
> 	Ingo

Thank you very much for your comment, Ingo.

-Fenghua
