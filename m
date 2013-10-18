Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab3JRJVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 05:21:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59823 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab3JRJVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 05:21:13 -0400
Date: Fri, 18 Oct 2013 11:20:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>, tony.luck@intel.com
Cc: joe@perches.com, naveen.n.rao@linux.vnet.ibm.com, m.chehab@samsung.com,
        arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/9] Extended H/W error log driver
Message-ID: <20131018092054.GB1007@pd.tnic>
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 04:23:35AM -0400, Chen, Gong wrote:
> OK, this is the 3rd version. Hope it is the last one :-).

It looks ok to me so far, I'm guessing Tony you're picking this up or
should I?

> this version just updates some minors places and apply some Ack/Review
> information. In this version I remove the last patch for trace
> interface. Maybe it is time to build a new RAS trace interface to
> integrate all RAS related error report interfaces now.

Yeah, let's start small here by moving the CREATE_TRACE_POINTS macro
definition to something like arch/x86/ras/core.c and work slowly up from
there. We have ras_event.h for tracepoints already.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
