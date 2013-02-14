Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934830Ab3BNSsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 13:48:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27764 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544Ab3BNSsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 13:48:14 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=1ADFm0T--rEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=mYRWiXiH8qgA:10 a=qt-cEr8D9w_SCmFrzwcA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360867691.23152.48.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH] printk: Remove separate printk_sched buffers and
 use printk buf instead
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "kay.sievers" <kay.sievers@vrfy.org>
Date: Thu, 14 Feb 2013 13:48:11 -0500
In-Reply-To: <20130212122245.GB19583@quack.suse.cz>
References: <1360112748.2621.25.camel@gandalf.local.home>
	 <20130206230220.GA18329@quack.suse.cz>
	 <20130212122245.GB19583@quack.suse.cz>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 13:22 +0100, Jan Kara wrote:

> > Anyway, what do you guys think about this version?
>   Steven, Andrew, did you have a chance to look at my patches?

Can you resend without being attachments. Patches sent as attachments
seldom get reviewed.

-- Steve


