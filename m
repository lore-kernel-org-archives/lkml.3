Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab3BXL25 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 06:28:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60389 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085Ab3BXL2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 06:28:55 -0500
Date: Sun, 24 Feb 2013 12:28:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        Borislav Petkov <bp@suse.de>, Peter Feuerer <peter@piie.net>,
        Andreas Mohr <andi@lisas.de>, Alexander Lam <azl@andrew.cmu.edu>
Subject: Re: [PATCH] acerhdf: Fix fan activation with new thermal governor
Message-ID: <20130224112851.GA19609@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Durgadoss R <durgadoss.r@intel.com>, Borislav Petkov <bp@suse.de>,
	Peter Feuerer <peter@piie.net>, Andreas Mohr <andi@lisas.de>,
	Alexander Lam <azl@andrew.cmu.edu>
References: <20130222111521.GA25473@pd.tnic>
 <1361647210-12983-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1361647210-12983-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2013 at 08:20:10PM +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> The new step_wise thermal governor wasn't able to handle the one-trip
> point design of acerhdf where we want to turn off the fan if we go under
> the 'fanoff' temperature and to turn it on only after exceeding the
> 'fanon' temperature.
> 
> Do that by looking at the current fan state and return the temperature
> accordingly.
> 
> Suggested-by: Zhang Rui <rui.zhang@intel.com>
> Cc: Peter Feuerer <peter@piie.net>
> Cc: Andreas Mohr <andi@lisas.de>
> Cc: Alexander Lam <azl@andrew.cmu.edu>
> Signed-off-by: Borislav Petkov <bp@suse.de>

Ok, ignore this one for now - the suspend/resume path doesn't pan out
somehow, need to do some more handholding here.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
