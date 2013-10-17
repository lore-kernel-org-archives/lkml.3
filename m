Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab3JQNFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:05:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59406 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811Ab3JQNFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:05:08 -0400
Date: Thu, 17 Oct 2013 15:04:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Tony Luck <tony.luck@gmail.com>, Chen Gong <gong.chen@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: Extended H/W error log driver
Message-ID: <20131017130451.GG5036@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <20131011080427.GC18719@pd.tnic>
 <20131014064940.GD12189@gchen.bj.intel.com>
 <20131014105533.GF4009@pd.tnic>
 <20131015040731.GA887@gchen.bj.intel.com>
 <20131015092851.GA7908@pd.tnic>
 <CA+8MBbJeSJBDPcomupOuVBrnZNkMTNTXsoZY9yUbXPe9YrTFXg@mail.gmail.com>
 <20131015191040.GA4347@naverao1-tp.ibm.com>
 <20131015192353.GI7908@pd.tnic>
 <525FD2FA.8010403@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <525FD2FA.8010403@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 05:37:22PM +0530, Naveen N. Rao wrote:
> That's me raising both my hands :)

:-)

> If you feel so strongly about it. "Corrected Error" is an oxymoron.
> It's really just the hardware notifying us.

Yeah, but we can't write

"We just corrected a single-bit flip in DIMM array <foo> - it was
supposed to be X but now it is Y. Don't worry, this bit flip had no
effect on current architectural machine state."

either.

I just don't want to call a "Hardware Error" a "Hardware Event".
Besides, an IRQ is a hardware event too, for example. You can see where
I'm getting with this...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
