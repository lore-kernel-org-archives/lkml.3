Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab3AVRYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:24:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29937 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3AVRYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:24:39 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Yx4KJSfXDHoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=XVkAhMFrrdMA:10 a=3wD4zJs4LYkSwtiEOXQA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358875477.21576.53.camel@gandalf.local.home>
Subject: Re: [PATCH RT] Fix v3.2.37-rt55 build break
From: Steven Rostedt <rostedt@goodmis.org>
To: John Kacur <jkacur@redhat.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>
Date: Tue, 22 Jan 2013 12:24:37 -0500
In-Reply-To: <alpine.LFD.2.03.1301221804320.14732@tycho>
References: <alpine.LFD.2.03.1301221804320.14732@tycho>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-22 at 18:15 +0100, John Kacur wrote:

> The following is my fix applied to the rt-kernel, but it's fine with
> me if you want to do the cherry-pick against the stable kernel,
> and then respin fix-rt-int3-x86_32-3.2-rt.patch

Does this fail on vanilla 3.2.37 as well? If so, we need to push it to
mainline stable, and then wait for it to be included for -rt.

-- Steve


