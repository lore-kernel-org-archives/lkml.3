Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaFEQrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 12:47:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48612 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaFEQrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 12:47:02 -0400
Date: Thu, 5 Jun 2014 18:44:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Matt Fleming <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/efi] x86/efi: Check for unsafe dealing with FPU state
 in irq ctxt
Message-ID: <20140605164433.GH16642@pd.tnic>
References: <20140605090206.GA16642@pd.tnic>
 <CALCETrU2TZhxOZyCvBd1nLDiU4ceiSx_Sd2bsDUCX5arOFidBg@mail.gmail.com>
 <20140605155307.GD16642@pd.tnic>
 <CALCETrVqqgExhuAYawh_7tc8-Nm8GGiMxmtw25mLFoxru-odZg@mail.gmail.com>
 <20140605160842.GE16642@pd.tnic>
 <CALCETrUors-39hUxS9Bg-dh+DzMcmPOs=6t998sbCVjqXYgyug@mail.gmail.com>
 <20140605161834.GF16642@pd.tnic>
 <53909B50.50407@zytor.com>
 <20140605163711.GG16642@pd.tnic>
 <53909E46.4020904@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53909E46.4020904@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 09:43:50AM -0700, H. Peter Anvin wrote:
> I'm sorry I don't follow.

Exactly what you said in the other mail to Andy: a dedicated XSAVE
buffer for EFI.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
