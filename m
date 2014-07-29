Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbaG2XBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:01:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57037 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbaG2XBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:01:08 -0400
Date: Wed, 30 Jul 2014 01:01:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: David Rientjes <rientjes@google.com>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        lszubowi@redhat.com, Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
Message-ID: <20140729230102.GD17241@pd.tnic>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com>
 <20140729222932.GA17481@pd.tnic>
 <53D82118.6090202@redhat.com>
 <20140729223603.GC17241@pd.tnic>
 <alpine.DEB.2.02.1407291541480.20991@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407291541480.20991@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 03:42:55PM -0700, David Rientjes wrote:
> If Prarit is going to implement this suggested reverse memparse() ...

The only meaningful argument about the formatting here IMO is what
people staring at this output are going to understand from it.

And since those people most often tend to be the poor souls dealing with
UEFI, we should ask them whether this needs fixing and if so, how.

That's it.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
