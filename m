Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbaG2WgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:36:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58214 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaG2WgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:36:09 -0400
Date: Wed, 30 Jul 2014 00:36:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, lszubowi@redhat.com,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
Message-ID: <20140729223603.GC17241@pd.tnic>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com>
 <20140729222932.GA17481@pd.tnic>
 <53D82118.6090202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53D82118.6090202@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 06:32:56PM -0400, Prarit Bhargava wrote:
> and it was best to keep the code simple with a KiB.

You're missing the point - the output doesn't get simple with KiB. Read
the example I just gave you!

(13893632kiB) is actively *not* helping when one looks at it!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
