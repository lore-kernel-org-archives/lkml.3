Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934164Ab3E1Na7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:30:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11623 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933952Ab3E1Na5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:30:57 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=FuXyT9YstboA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=W9-82xvkzVUA:10 a=ayC55rCoAAAA:8 a=55xwRc_B_ddNZ_X0jRYA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369747853.15552.9.camel@gandalf.local.home>
Subject: Re: [PATCH] x86: Have debug/nmi restore the IDT it replaced
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>
Date: Tue, 28 May 2013 09:30:53 -0400
In-Reply-To: <20130528075441.GA28601@gmail.com>
References: <1369360404.6828.219.camel@gandalf.local.home>
	 <20130528075441.GA28601@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-28 at 09:54 +0200, Ingo Molnar wrote:

> Hm, patch got totally whitespace corrupted.

Hmm, interesting, not sure what happened. OK, I'll resend. Maybe
evolution did a nasty.

Thanks,

-- Steve


