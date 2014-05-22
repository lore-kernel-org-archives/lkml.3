Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154AbaEVRKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 13:10:16 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40447 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbaEVRKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 13:10:14 -0400
Date: Thu, 22 May 2014 10:09:55 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Maynard Johnson <mpjohn@us.ibm.com>, Ulrich.Weigand@de.ibm.com,
        Anton Blanchard <anton@au1.ibm.com>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au
Subject: Re: [PATCH 1/1] powerpc/perf: Adjust callchain based on DWARF debug
Message-ID: <20140522170955.GB6318@us.ibm.com>
References: <20140521012644.GA2890@us.ibm.com>
 <20140522100045.GA4789@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522100045.GA4789@krava.brq.redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052217-7182-0000-0000-00000AAA3BD7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa [jolsa@redhat.com] wrote:
| 
| yep, that sounds more clear to me.. something like below?
| 
| calling callchain_dup from within arch_adjust_callchain in case
| you want to change it and returning != 0 in this case, so
| we could free the new callchain

Agree.

| 
| but it might be to much overhead in case you have the support to skip
| just one entry now right? is there a plan for more cleaning? ;)

Its only one entry AFACIT. No plans for other changes, so will rename
the function as you mention in the other message and will resend.

Thanks,

Sukadev

