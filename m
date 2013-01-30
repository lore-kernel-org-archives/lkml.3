Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3A3DmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:42:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39499 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab3A3DmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:42:08 -0500
Date: Wed, 30 Jan 2013 04:42:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Message-ID: <20130130034204.GB30965@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
	lkml <linux-kernel@vger.kernel.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <20130129202848.GE25415@pd.tnic>
 <CAErSpo4v473sXvmv3gqkftkiFZtz+gYgd1yzWae=nLJjwJPBug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAErSpo4v473sXvmv3gqkftkiFZtz+gYgd1yzWae=nLJjwJPBug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 02:32:56PM -0700, Bjorn Helgaas wrote:
> Konstantin has some fixes for an e1000e power management issue related
> to suspend/resume that he observed on an x220. He didn't see an NMI,
> and apparently his problem has been around for a long time,

Yeah, this is one of those issues you don't see *every* s/r cycle and
besides, I just got this box and haven't run 3.{6,7} on it yet (maybe
never will :-)).

> so no idea whether it could be related. I just noticed the conjunction
> of thinkpad/e1000e/resume/power saving in both reports.
>
> https://lkml.org/lkml/2013/1/18/147

Yes, thanks Bjorn, that was a good suggestion. Btw, from reading the
thread, those patches still need cooking a bit more, AFAICR people's
objections/comments. Or should I go ahead and test them?

It's just that I'm overly cautious every time I hear e1000e is involved:

www.linux-magazine.com/content/download/62169/484085/file/Security_Lessons_Ftrace.pdf

:-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
