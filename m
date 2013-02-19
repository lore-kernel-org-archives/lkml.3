Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab3BSEGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 23:06:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29962 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab3BSEGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 23:06:43 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=btn4o-XVpwEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=5m8K6IL_vW8A:10 a=b7AVe0XaBIFk4HxM3DgA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1361246801.23152.195.camel@gandalf.local.home>
Subject: Re: [PREEMPT RT] SLUB and split softirq lock for v3.2-rt
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>
Date: Mon, 18 Feb 2013 23:06:41 -0500
In-Reply-To: <5122DBC1.6010507@huawei.com>
References: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
	 <1360776274.23152.7.camel@gandalf.local.home> <5122DB72.7030100@huawei.com>
	 <5122DBC1.6010507@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-19 at 09:56 +0800, Li Zefan wrote:

> Oh ignore me. Just saw the patchset for 3.4-rt.

Note, I already have part of the 3.4-feature (softirq backport) tested
and ready. What I'm waiting on is trying to figure out the best way to
process it.

I already know I'll have a v3.4-features branch, but I'm thinking about
patches and tarballs, if it should be posted as well, or just be in git?

If I choose to post them, I want the scripts done before I do so, but
right now I'll be leaving for ELC and wont get to it till I get back.

-- Steve


