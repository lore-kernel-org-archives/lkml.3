Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbaGBBNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 21:13:50 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60530 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaGBBNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 21:13:49 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jul 2014 21:13:49 EDT
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219
Date: Wed, 02 Jul 2014 10:07:14 +0900 (JST)
Message-Id: <20140702.100714.29478419.d.hatayama@jp.fujitsu.com>
To: ak@linux.intel.com
Cc: hpa@zytor.com, dzickus@redhat.com, matt@console-pimps.org,
        peterz@infradead.org, acme@kernel.org, mingo@redhat.com,
        paulus@samba.org, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] perf/x86/intel: ignore CondChgd bit to avoid false
 NMI handling
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20140630222224.GH19781@tassilo.jf.intel.com>
References: <20140616153047.GJ177152@redhat.com>
	<53B12CB3.5050508@jp.fujitsu.com>
	<20140630222224.GH19781@tassilo.jf.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v2] perf/x86/intel: ignore CondChgd bit to avoid false NMI handling
Date: Mon, 30 Jun 2014 15:22:24 -0700

>> 
>> I'm also interested in the behaviour of CondChgd bit on Ivy Bridge processors.
> 
> The intended meaning of CondChgd is that a hardware debugger has taken over the
> PMU. It shouldn't really be set in other circumstances.
> 

Thanks for your explanation.

The hardware debugger you mean is a kind of ITP?

> I think right now for perf it would be best to just ignore it.
> 
> In theory could stop using the PMU, but if some BIOS set it it would
> completely disable perf there. So better to just ignore it.
> 

I'll reflect this information in the patch description.

--
Thanks.
HATAYAMA, Daisuke

