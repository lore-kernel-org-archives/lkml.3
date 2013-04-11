Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936153Ab3DKOk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:40:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29224 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932712Ab3DKOk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:40:56 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=hhH8zwMFE54A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=bUzm9BIBfnIA:10 a=57SyGIRnAAAA:8 a=sqimn8mf1ZHBRFsDjecA:9 a=QEXdDO2ut3YA:10 a=TIV7c6GJmisA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365691255.9609.34.camel@gandalf.local.home>
Subject: Re: [PATCH 5/6] tools lib traceevent: Add page_size field to pevent
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 11 Apr 2013 10:40:55 -0400
In-Reply-To: <1365691175.9609.33.camel@gandalf.local.home>
References: <1365681898-19897-1-git-send-email-namhyung@kernel.org>
	 <1365681898-19897-5-git-send-email-namhyung@kernel.org>
	 <1365691175.9609.33.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 10:39 -0400, Steven Rostedt wrote:
> On Thu, 2013-04-11 at 21:04 +0900, Namhyung Kim wrote:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > It's for saving the page size of traced system.
> 
> Can you add a bit more detail in the change log about why this patch is
> necessary.

For now, you can add my

Acked-by: Steven Rostedt <rostedt@goodmis.org>

for all but this patch.

I just want to know more about this patch before I ack it.

Thanks,

-- Steve


