Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab3HEVlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 17:41:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41297 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506Ab3HEVlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 17:41:42 -0400
Date: Mon, 5 Aug 2013 23:41:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Fish <afish@apple.com>, edk2-devel@lists.sourceforge.net,
        Laszlo Ersek <lersek@redhat.com>, linux-efi@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [edk2] Corrupted EFI region
Message-ID: <20130805214140.GB14067@pd.tnic>
References: <20130801164927.GA7445@pd.tnic>
 <51FF8C14.2070405@redhat.com>
 <20130805130258.GB31845@pd.tnic>
 <51FFAB13.4090603@redhat.com>
 <20130805140306.GD31845@pd.tnic>
 <51FFB660.4060400@redhat.com>
 <20130805144010.GE31845@pd.tnic>
 <2DBE3EA4-E321-4A7B-B9AF-EDE55BC2E358@apple.com>
 <20130805181225.GH31845@pd.tnic>
 <52001B04.2050806@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52001B04.2050806@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 02:37:08PM -0700, H. Peter Anvin wrote:
> All of this would be a non-problem if there weren't buggy
> implementations which can't run *without* SetVirtualAddressMap().

Oh, you mean, if we were to call the runtime services through their
physical addresses?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
