Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaJ1V0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:26:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33550 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587AbaJ1V0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:26:46 -0400
Date: Tue, 28 Oct 2014 22:26:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mathias Krause <minipli@googlemail.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCHv2 1/3] x86, ptdump: Add section for EFI runtime services
Message-ID: <20141028212642.GH10873@pd.tnic>
References: <20141007150132.GA7307@nazgul.tnic>
 <20141007170748.GA25767@jig.fritz.box>
 <20141008151730.GB16892@pd.tnic>
 <CA+rthh_Q0HQfLX6P3kcuOUwggjSnhYGCc5YJNOn0UCCRPZbaxA@mail.gmail.com>
 <20141008222619.GG16892@pd.tnic>
 <20141012125515.GA32045@jig.fritz.box>
 <20141028185756.GD10873@pd.tnic>
 <CA+rthh9qePkJogFDT+ttSLvYPvJrAM6CXMJ407Hq3PjcRw9WTw@mail.gmail.com>
 <20141028201342.GG10873@pd.tnic>
 <CA+rthh9LSRm12qYORAd5BWzpw7DEP7hqHLA3EDdfUDxwx-4=2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+rthh9LSRm12qYORAd5BWzpw7DEP7hqHLA3EDdfUDxwx-4=2g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 10:14:25PM +0100, Mathias Krause wrote:
> Oh, well. Have fun with that! I would take the "map kernel into EFI
> page table" route instead. ;)

Actually, I want to try to keep them completely separate and sync only
before an EFI RT call for function arguments. And then remove PGDs after
I return from it. We'll see how it all works out.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
