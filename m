Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037AbaDOD1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 23:27:30 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:41103 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaDOD13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 23:27:29 -0400
Message-ID: <1397532444.4223.1.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [tip:x86/urgent] x86 idle: Repair large-server 50-watt
 idle-power regression
From: Davidlohr Bueso <davidlohr@hp.com>
To: "Brown, Len" <len.brown@intel.com>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Mon, 14 Apr 2014 20:27:24 -0700
In-Reply-To: <1A7043D5F58CCB44A599DFD55ED4C94845CA12EC@fmsmsx115.amr.corp.intel.com>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
	 <baff264285f6e585df757d58b17788feabc68918.1387403066.git.len.brown@intel.com>
	 <tip-40e2d7f9b5dae048789c64672bf3027fbb663ffa@git.kernel.org>
	 <1395102010.2474.21.camel@buesod1.americas.hpqcorp.net>
	 <1A7043D5F58CCB44A599DFD55ED4C94845CA12EC@fmsmsx115.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-08 at 21:43 +0000, Brown, Len wrote:
> Davidlohr,
> 
> Thanks for the note.
> 
> Ideally (on Linux in general, and on servers, in particular) we strive
> for the performance impact of power saving features to be small enough
> to be considered in "measurement noise".
> 
> Your report for 160 core Westmere AIM numbers being hit at 10-25%
> shows 15% measurement noise?  But even if true, this looks bad.
> 
> Any chance you can re-run, with the following two tweaks,
> one at a time?
> 
> I'd be curious if you can wrap the invocation in turbostat -v
> and capture that output to how what states we are seeing
> during the benchmark run.

Hi Len, apologies for the delay, I've been having to use my machine for
other things and haven't gotten time to get around to this yet. I'll get
you the requested information sometime this week.

