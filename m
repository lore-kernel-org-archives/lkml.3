Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964819Ab3BMRYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:24:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5848 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934457Ab3BMRYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:24:36 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=btn4o-XVpwEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=5m8K6IL_vW8A:10 a=9fWZkWeYtoac_3kBRgwA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360776274.23152.7.camel@gandalf.local.home>
Subject: Re: [PREEMPT RT] SLUB and split softirq lock for v3.2-rt
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>
Date: Wed, 13 Feb 2013 12:24:34 -0500
In-Reply-To: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
References: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 17:11 +0100, Sebastian Andrzej Siewior wrote:
> 3.2-rt is a long term supported kernel, which lacks two RT features
> from 3.6: SLUB support and the split softirq lock implementation.
> 
> SLUB has a way better performance than SLAB on RT and the split
> softirq lock implementation is necessary especially for realtime
> networking applications.
> 
> The following patch series backports these features to 3.2-rt.
> 
> Steven, could you please apply these patches to a separate
> 3.2-rt-features branch?

Is it possible to separate these two features into two different patch
sets. I would like to apply the softirq changes first, and then apply
the slub changes.

Although it looks as though the first half is softirq only 1-8, and the
second half is slub related 9-16. If that's the case, I'll just pull in
1-8 first, play with them, and then do 9-16.

Thanks,

-- Steve


