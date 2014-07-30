Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbaG3T6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 15:58:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56248 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbaG3T63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 15:58:29 -0400
Date: Wed, 30 Jul 2014 21:58:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Prarit Bhargava <prarit@redhat.com>,
        Matt Fleming <matt@console-pimps.org>,
        Colin Ian King <colin.king@canonical.com>,
        linux-kernel@vger.kernel.org, lszubowi@redhat.com,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
Message-ID: <20140730195821.GE10213@pd.tnic>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com>
 <20140729222932.GA17481@pd.tnic>
 <20140730144803.GB15082@console-pimps.org>
 <53D909C3.9050205@canonical.com>
 <53D9259F.5050307@redhat.com>
 <53D92700.3040803@infradead.org>
 <53D92996.1050906@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53D92996.1050906@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 10:21:26AM -0700, H. Peter Anvin wrote:
> Arguably the exactness is available in the range...

... and the size too. FWIW, other region dumps don't even print size:

[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009e7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
...

If we do that too for UEFI, we can certainly put an end to the
bikeshedding... provided everyone is tired of it by now. :-P

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
