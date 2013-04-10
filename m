Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935062Ab3DJAPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:15:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29560 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762266Ab3DJAPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:15:30 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=gifVZ8yEhnkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=QTktqBR0uL0A:10 a=57SyGIRnAAAA:8 a=VwQbUJbxAAAA:8 a=sYQNw-pFXK1ZfffFw5QA:9 a=QEXdDO2ut3YA:10 a=TIV7c6GJmisA:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365552927.25498.82.camel@gandalf.local.home>
Subject: Re: [PATCH v2 3/3] ftrace: Get rid of ftrace_profile_bits
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Tue, 09 Apr 2013 20:15:27 -0400
In-Reply-To: <1365551750-4504-1-git-send-email-namhyung@kernel.org>
References: <1365548611.25498.79.camel@gandalf.local.home>
	 <1365551750-4504-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 08:55 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> It seems that function profiler's hash size is fixed at 1024.  Add and
> use FTRACE_PROFILE_HASH_BITS instead and update hash size macro.

Thanks! I'll queue it in my 3.10 branch.

-- Steve

> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---


