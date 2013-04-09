Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765173Ab3DIW6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 18:58:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27841 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3DIW6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 18:58:17 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Qp2S8Rs-8YMA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=t72ugolhqXYA:10 a=57SyGIRnAAAA:8 a=5UjIYMNU4euyi6OtZdsA:9 a=QEXdDO2ut3YA:10 a=TIV7c6GJmisA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365548296.25498.78.camel@gandalf.local.home>
Subject: Re: [PATCH 3/3] ftrace: Constify ftrace_profile_bits
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Tue, 09 Apr 2013 18:58:16 -0400
In-Reply-To: <1364820385-32027-3-git-send-email-namhyung@kernel.org>
References: <1364820385-32027-1-git-send-email-namhyung@kernel.org>
	 <1364820385-32027-3-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-01 at 21:46 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> It seems that function profiler's hash size is fixed at 1024.
> Make the ftrace_profile_bits const and update hash size macro.
> 

Thanks for the fixes. As patch 1/3 fixes a real bug (one that can cause
a panic), I've labeled it as stable and will push it for 3.9.

Patch 2/3 just saves memory. I'll mark it stable, but it can wait to go
into 3.10.

This patch is more of a clean up, and will only go into 3.10.

Thanks!

-- Steve


