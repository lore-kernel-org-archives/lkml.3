Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab3E1SpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 14:45:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24413 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab3E1SpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 14:45:15 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ntv_MHBx4dgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=j6BnnTXjCdIA:10 a=4LFf1yYZOXqiC5F5GJQA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369766714.15552.15.camel@gandalf.local.home>
Subject: Re: [PATCH] 9p: trace: use %*ph to dump buffer
From: Steven Rostedt <rostedt@goodmis.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Tue, 28 May 2013 14:45:14 -0400
In-Reply-To: <1369730992.29283.224.camel@smile>
References: <1366635713-11435-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1369730992.29283.224.camel@smile>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-28 at 11:49 +0300, Andy Shevchenko wrote:

> Any comment on this one, anyone?
> 

Tracepoints are the responsibility of the maintainers that the code they
reside in. But I like to be Cc'd just to make sure things are not done
incorrectly.

This change looks fine to me, but thanks for Cc'ing me, as the
libtraceevent needs to be updated to handle this change, such that perf
can parse it too.

-- Steve


