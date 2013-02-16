Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab3BPCii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 21:38:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23624 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3BPCig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 21:38:36 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=8jnvGVjTqY4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=_67WK3i7ub8A:10 a=oLthj8BuYLb_eeJblt0A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360982314.23152.125.camel@gandalf.local.home>
Subject: Re: [PATCH v9 2/3] trace,x86: add x86 irq vector tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Date: Fri, 15 Feb 2013 21:38:34 -0500
In-Reply-To: <511EEAE1.1040106@zytor.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A64C4B@USINDEM103.corp.hds.com>
	  <511ECE53.8040801@zytor.com>
	 <1360979993.23152.122.camel@gandalf.local.home>
	 <511EEAE1.1040106@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-15 at 18:11 -0800, H. Peter Anvin wrote:

> Not-yet-signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Also note that the "Not-yet-signed-off-by" was to let people know that,
even though I ran it through various tests, I did not run it through my
main test suite.

I probably wont change it much, if at all, but I didn't want anyone
using it yet.

Kind of like the way Paul McKenney always says "not yet ready for
inclusion".

-- Steve



