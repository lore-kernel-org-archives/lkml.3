Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab3CFHBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:01:05 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42282 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab3CFHBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:01:01 -0500
Date: Wed, 6 Mar 2013 08:00:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Andreas Mohr <andi@lisas.de>, Peter Feuerer <peter@piie.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Durgadoss R <durgadoss.r@intel.com>,
        Alexander Lam <azl@andrew.cmu.edu>
Subject: Re: [PATCH] acerhdf: Fix fan activation with new thermal governor
Message-ID: <20130306070057.GA30673@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Zhang Rui <rui.zhang@intel.com>, Andreas Mohr <andi@lisas.de>,
	Peter Feuerer <peter@piie.net>, LKML <linux-kernel@vger.kernel.org>,
	Durgadoss R <durgadoss.r@intel.com>,
	Alexander Lam <azl@andrew.cmu.edu>
References: <1361647210-12983-1-git-send-email-bp@alien8.de>
 <20130224112851.GA19609@pd.tnic>
 <cone.1361706175.908398.1806.1000@galar>
 <20130224143452.GE19609@pd.tnic>
 <1361762514.2303.21.camel@rzhang1-mobl4>
 <20130225102526.GB12067@pd.tnic>
 <20130225121608.GC12067@pd.tnic>
 <20130304133410.GC22274@pd.tnic>
 <20130305215946.GA16796@rhlx01.hs-esslingen.de>
 <1362541640.2441.3.camel@rzhang1-mobl4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1362541640.2441.3.camel@rzhang1-mobl4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 11:47:20AM +0800, Zhang Rui wrote:
> > So this now does not have any of the Schmitt trigger equivalent (?)
> > governor changes that were nicely discussed in this activity -
> > So what do we want to have committed, and what do we not,
> 
> the problem should have been fixed in 3.9-rc1 by
> commit b8bb6cb999858043489c1ddef08eed2127559169
> Author: Zhang Rui <rui.zhang@intel.com>
> Date:   Thu Nov 22 15:45:02 2012 +0800
> 
>     step_wise: Unify the code for both throttle and dethrottle
> 
>     Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> 
> I'll send Alexander' patch for 3.8 stable.

Hold on, do I understand it correctly that this is yet another patch
that "fixes" it? If so, maybe we should test 3.9-rc1 which contains the
said patch above? Yes, no?

Also, I don't see Alexander's patch applied anywhere so if it isn't
upstream, you can't send it to stable.

Please clarify,

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
