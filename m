Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab3CFHg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:36:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42431 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526Ab3CFHgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:36:12 -0500
Date: Wed, 6 Mar 2013 08:36:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Andreas Mohr <andi@lisas.de>, Peter Feuerer <peter@piie.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Durgadoss R <durgadoss.r@intel.com>,
        Alexander Lam <azl@andrew.cmu.edu>
Subject: Re: [PATCH] acerhdf: Fix fan activation with new thermal governor
Message-ID: <20130306073609.GB30673@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Zhang Rui <rui.zhang@intel.com>, Andreas Mohr <andi@lisas.de>,
	Peter Feuerer <peter@piie.net>, LKML <linux-kernel@vger.kernel.org>,
	Durgadoss R <durgadoss.r@intel.com>,
	Alexander Lam <azl@andrew.cmu.edu>
References: <cone.1361706175.908398.1806.1000@galar>
 <20130224143452.GE19609@pd.tnic>
 <1361762514.2303.21.camel@rzhang1-mobl4>
 <20130225102526.GB12067@pd.tnic>
 <20130225121608.GC12067@pd.tnic>
 <20130304133410.GC22274@pd.tnic>
 <20130305215946.GA16796@rhlx01.hs-esslingen.de>
 <1362541640.2441.3.camel@rzhang1-mobl4>
 <20130306070057.GA30673@pd.tnic>
 <1362555028.2441.21.camel@rzhang1-mobl4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1362555028.2441.21.camel@rzhang1-mobl4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 03:30:28PM +0800, Zhang Rui wrote:
> sorry I should be clearer. the problem that alexander' patch fixes,
> does not exist in 3.9-rc1 because the problem is fixed by this commit
> b8bb6cb999858043489c1ddef08eed2127559169.
>
> so what we need is, either 3.8.x kernel + alexander's patch, or clean
> 3.9-rc1.

Ok, understood now. I'll run -rc1 to verify the fix.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
