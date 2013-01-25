Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab3AYRI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:08:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17699 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987Ab3AYRIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:08:25 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=jPgbAdZAaisA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=88l9eXxIsI4A:10 a=l5ZUUOtXD1rE0nuk8SAA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359133703.21576.233.camel@gandalf.local.home>
Subject: Re: [PATCH 19/19] [INCOMPLETE] ARM: make return_address available
 for ARM_UNWIND
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Martin <dave.martin@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        sahara <keun-o.park@windriver.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 25 Jan 2013 12:08:23 -0500
In-Reply-To: <20130125165934.GE2069@linaro.org>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
	 <1359123276-15833-20-git-send-email-arnd@arndb.de>
	 <20130125162608.GD2069@linaro.org>
	 <1359132254.21576.230.camel@gandalf.local.home>
	 <20130125165934.GE2069@linaro.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-25 at 16:59 +0000, Dave Martin wrote:

> Cool.  Are you aware of return_address being used elsewhere?  Currently
> I'm not aware of anything else which uses it, and grep is not finding
> any calls outside ftrace.h that I can see.

softirq.c has a trace_preempt_off() use of CALLER_ADDR1.

kernel/sched/core.c has CALLER_ADDR1, 2 an 3.

-- Steve


