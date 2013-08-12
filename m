Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab3HLMxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 08:53:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49368 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab3HLMxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 08:53:45 -0400
Date: Mon, 12 Aug 2013 14:53:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, tony.luck@intel.com,
        bhelgaas@google.com, rostedt@goodmis.org, rjw@sisk.pl,
        lance.ortiz@hp.com, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Message-ID: <20130812125343.GE18018@pd.tnic>
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <20130808163822.67e0828a@samsung.com>
 <20130810180322.GC4155@pd.tnic>
 <20130812083355.47c1bae8@samsung.com>
 <5208D80D.5030206@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5208D80D.5030206@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 06:11:49PM +0530, Naveen N. Rao wrote:
> So, I looked at ghes_edac and it basically seems to boil down to
> trace_mc_event. But, this only seems to expose the APEI data as a
> string and doesn't look to really make all the fields available to
> user-space in a raw manner. Not sure how well this can be utilised
> by a user-space tool.

Well, your tracepoint dumps the decoded memory error too. So all the
information we need is already there, without edac. Or am I missing some
bits?

Thus why I'm saying is that we don't need the additional edac layer.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
