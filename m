Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab3DMB0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 21:26:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13955 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3DMB0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 21:26:51 -0400
X-Authority-Analysis: v=2.0 cv=Pu4Rnnw3 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=hhH8zwMFE54A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=bUzm9BIBfnIA:10 a=EJjMaSweEl1vZREuQncA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365816410.9609.106.camel@gandalf.local.home>
Subject: Re: [PATCH 5/6] tools lib traceevent: Add page_size field to pevent
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 12 Apr 2013 21:26:50 -0400
In-Reply-To: <1365815846.1769.11.camel@leonhard>
References: <1365681898-19897-1-git-send-email-namhyung@kernel.org>
	 <1365681898-19897-5-git-send-email-namhyung@kernel.org>
	 <1365691175.9609.33.camel@gandalf.local.home>
	 <1365691255.9609.34.camel@gandalf.local.home>
	 <1365815846.1769.11.camel@leonhard>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-04-13 at 10:17 +0900, Namhyung Kim wrote:

> > 
> > I just want to know more about this patch before I ack it.
> 
> The page size of traced system can be different than current system's
> because the recorded data file might be analyzed in a different machine.
> In this case we should use original page size of traced system when
> accessing the data file, so this information needs to be saved.

I understand that, it's just strange that it's not used anywhere in the
library, or the patch series (that I can find).

It would make more sense if another patch used this new interface. I'm
sure new code will, but the patch should be part of a patch series that
needs it.

Thanks,

-- Steve


