Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab3BXMJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 07:09:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40582 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab3BXMJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 07:09:55 -0500
Date: Sun, 24 Feb 2013 13:09:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Durgadoss R <durgadoss.r@intel.com>, Borislav Petkov <bp@suse.de>,
        Andreas Mohr <andi@lisas.de>, Alexander Lam <azl@andrew.cmu.edu>
Subject: Re: [PATCH] acerhdf: Fix fan activation with new thermal governor
Message-ID: <20130224120952.GB19609@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Feuerer <peter@piie.net>, LKML <linux-kernel@vger.kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Durgadoss R <durgadoss.r@intel.com>, Borislav Petkov <bp@suse.de>,
	Andreas Mohr <andi@lisas.de>, Alexander Lam <azl@andrew.cmu.edu>
References: <20130222111521.GA25473@pd.tnic>
 <1361647210-12983-1-git-send-email-bp@alien8.de>
 <20130224112851.GA19609@pd.tnic>
 <cone.1361706175.908398.1806.1000@galar>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cone.1361706175.908398.1806.1000@galar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2013 at 12:42:55PM +0100, Peter Feuerer wrote:
> Hi Boris,
> 
> thanks for your best wishes in the last mail, I'm feeling little better now.

Nice :)

> Please test my last patch with the 4 trip points ;) - even if you
> don't really like it, it is working great! - And to be honest, I still
> prefer this solution!

Right, but 4 trip points for this simple driver is a bit of a overkill,
don't you think? If we want to be really accurate, we'd only need two,
think of three temperature intervals here:

0 - temp <= fanon
1 - fanon =< temp < crit
2 - temp >= crit

I need to go stare at it a bit more.

> Anyhow, did you test what Rui asked us to test?

Yep.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
