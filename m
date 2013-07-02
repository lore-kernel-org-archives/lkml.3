Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab3GBIR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 04:17:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53554 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167Ab3GBIR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 04:17:57 -0400
Date: Tue, 2 Jul 2013 10:17:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Wrapping EXPORT_SYMBOL_GPL symbols and re-exporting the wrappers
 with EXPORT_SYMBOL
Message-ID: <20130702081754.GA4535@pd.tnic>
References: <87bo6m2yok.fsf@nemi.mork.no>
 <20130701213859.GC23539@pd.tnic>
 <CAFLxGvw5byx2gu47oD5yOMSHHxieh8qs0z5ZyeCRpAi7T3ibOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFLxGvw5byx2gu47oD5yOMSHHxieh8qs0z5ZyeCRpAi7T3ibOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 09:57:08AM +0200, richard -rw- weinberger wrote:
> Then vendors will do a s/EXPORT_SYMBOL_GPL/EXPORT_SYMBOL/g on the kernel.

Huh, "fail building if a module does EXPORT_SYMBOL"...

> Recently I've identified such a case.

Regardless, there's not really a whole lot we can do technically as long
as they go and change the kernel. The EXPORT_SYMBOL_GPL thing protects
only against separately distributed modules but if you deliver the whole
kernel, you can do whatever you want. :-\

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
