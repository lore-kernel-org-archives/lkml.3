Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab3JTIVy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 04:21:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47067 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab3JTIVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 04:21:51 -0400
Date: Sun, 20 Oct 2013 10:21:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, tony.luck@intel.com,
        joe@perches.com, m.chehab@samsung.com, arozansk@redhat.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86
 platform
Message-ID: <20131020082148.GA3994@pd.tnic>
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
 <1382084624-10857-5-git-send-email-gong.chen@linux.intel.com>
 <52612BA4.2060906@linux.vnet.ibm.com>
 <20131020070615.GA30565@gchen.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131020070615.GA30565@gchen.bj.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, your mailer is generating that Mail-Followup-To header which
removes you from the To: list and puts everyone else on To: instead.

And of course, the patches you've sent with git-send-email don't have
that header and replying to all there is fine.

And Tony's replies don't have it so replying to him is fine.

>From reading this here: http://cr.yp.to/proto/replyto.html your mail
client seems to think you're subscribed to some list and thus drops your
mail address from Mail-Followup-To.

On Sun, Oct 20, 2013 at 03:06:15AM -0400, Chen Gong wrote:
> Oh, yes it is. Furthermore, it reminds me where is the best place
> to put cper.c from I write this patch series. CPER really doesn't
> dpend on APEI even ACPI. Maybe lib/ ia an option. I can update this
> patch and if it is OK, I can add another separate patch to change this
> dependency. Make sense?

Yeah, for some reason it is part of the UEFI spec but APEI uses it too.

Well, I guess you can add it there as "default n" and have the rest of
the code select it in Kconfig.

> Sigh, it looks like I have m a little bit hurry.

Yeah, why is that? :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
