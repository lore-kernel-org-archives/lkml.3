Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791Ab3CGU12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 15:27:28 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38006 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab3CGU10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 15:27:26 -0500
Date: Thu, 7 Mar 2013 21:27:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Peter Feuerer <peter@piie.net>
Cc: Andreas Mohr <andi@lisas.de>, Zhang Rui <rui.zhang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Durgadoss R <durgadoss.r@intel.com>,
        Alexander Lam <azl@andrew.cmu.edu>
Subject: Re: [PATCH] acerhdf: Fix fan activation with new thermal governor
Message-ID: <20130307202720.GB8284@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Feuerer <peter@piie.net>, Andreas Mohr <andi@lisas.de>,
	Zhang Rui <rui.zhang@intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Durgadoss R <durgadoss.r@intel.com>,
	Alexander Lam <azl@andrew.cmu.edu>
References: <20130222111521.GA25473@pd.tnic>
 <1361647210-12983-1-git-send-email-bp@alien8.de>
 <20130224112851.GA19609@pd.tnic>
 <cone.1361706175.908398.1806.1000@galar>
 <20130224143452.GE19609@pd.tnic>
 <1361762514.2303.21.camel@rzhang1-mobl4>
 <20130225102526.GB12067@pd.tnic>
 <20130225121608.GC12067@pd.tnic>
 <20130304133410.GC22274@pd.tnic>
 <cone.1362687423.847750.1921.1000@galar>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cone.1362687423.847750.1921.1000@galar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 09:17:03PM +0100, Peter Feuerer wrote:
> Finally I found some time to do a test run. I did a git clone on the
> Linus tree. But I was not able to apply this patch, seems like it has
> already been applied on mainline.

Yep, patch is in 3.9-rc1.

> Anyhow, with current git state acerhdf works flawlessly for me. I
> tried standard usage of the netbook and suspend.

Good, so we're all fine then, nice.

Thanks for testing.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
