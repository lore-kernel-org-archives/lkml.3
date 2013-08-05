Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab3HEOkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:40:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33844 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab3HEOkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:40:12 -0400
Date: Mon, 5 Aug 2013 16:40:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: Laszlo Ersek <lersek@redhat.com>
Cc: edk2-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
        linux-efi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [edk2] Corrupted EFI region
Message-ID: <20130805144010.GE31845@pd.tnic>
References: <20130731205431.GG4724@pd.tnic>
 <1375307727.22084.103.camel@shinybook.infradead.org>
 <20130801164927.GA7445@pd.tnic>
 <51FF8C14.2070405@redhat.com>
 <20130805130258.GB31845@pd.tnic>
 <51FFAB13.4090603@redhat.com>
 <20130805140306.GD31845@pd.tnic>
 <51FFB660.4060400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51FFB660.4060400@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 04:27:44PM +0200, Laszlo Ersek wrote:
> I wouldn't call the design of SetVirtualAddressMap() braindead.

Ok, I've always wondered and you could probably shed some light on the
matter: why is SetVirtualAddressMap() a call-once only? Why can't I
simply call it again and update the mappings?

> I'd rather call kexec unique and somewhat unexpected :)

In all fairness, it was there before UEFI, AFAICT.

> > I wouldn't wonder if we f*cked it up again like the last time. I'll give
> > it a long hard look.
> 
> Ah sorry, by "and you guys suspect" I didn't mean to imply anything
> between the lines, I was simply trying to ascertain your working idea :)

As long as we get to the bottom of this, we're all fine. And I'd
pretty much expect everyone who is dealing with EFI to have grown a
sufficiently thick skin before starting to do so, so don't worry.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
