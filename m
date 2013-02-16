Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab3BPVr0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 16:47:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34140 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab3BPVrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 16:47:25 -0500
Date: Sat, 16 Feb 2013 22:47:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alexander Lam <azl@andrew.cmu.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Feuerer <peter@piie.net>, Andreas Mohr <andi@lisas.de>
Subject: Re: thermal governor: does it actually work??
Message-ID: <20130216214712.GA13494@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alexander Lam <azl@andrew.cmu.edu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Peter Feuerer <peter@piie.net>, Andreas Mohr <andi@lisas.de>
References: <20130214153255.GA5033@rhlx01.hs-esslingen.de>
 <744357E9AAD1214791ACBA4B0B90926329ED72@SHSMSX101.ccr.corp.intel.com>
 <20130215154931.GA26213@rhlx01.hs-esslingen.de>
 <CACWwPiuk0GynEwe3RuKndWnsYwTuPhO0ob6sJ6ve34u1_RtkYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACWwPiuk0GynEwe3RuKndWnsYwTuPhO0ob6sJ6ve34u1_RtkYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 04:08:11PM -0500, Alexander Lam wrote:
> I wrote a patch to fix this:
> 
> http://lkml.org/lkml/2012/12/30/47
> 
> But nobody picked it up and since then I have been too busy to respin
> the patch for new -rc kernels.

Hmm,

that's definitely worth a try - we've been discussing maybe the same
issue with acerhdf recently. Peter, Andreas?

I'll try to test it soon too.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
