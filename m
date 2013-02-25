Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342Ab3BYMQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 07:16:14 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46143 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756622Ab3BYMQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 07:16:13 -0500
Date: Mon, 25 Feb 2013 13:16:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Peter Feuerer <peter@piie.net>, LKML <linux-kernel@vger.kernel.org>,
        Durgadoss R <durgadoss.r@intel.com>, Andreas Mohr <andi@lisas.de>,
        Alexander Lam <azl@andrew.cmu.edu>, bp@suse.de
Subject: Re: [PATCH] acerhdf: Fix fan activation with new thermal governor
Message-ID: <20130225121608.GC12067@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Zhang Rui <rui.zhang@intel.com>, Peter Feuerer <peter@piie.net>,
	LKML <linux-kernel@vger.kernel.org>,
	Durgadoss R <durgadoss.r@intel.com>, Andreas Mohr <andi@lisas.de>,
	Alexander Lam <azl@andrew.cmu.edu>
References: <20130222111521.GA25473@pd.tnic>
 <1361647210-12983-1-git-send-email-bp@alien8.de>
 <20130224112851.GA19609@pd.tnic>
 <cone.1361706175.908398.1806.1000@galar>
 <20130224143452.GE19609@pd.tnic>
 <1361762514.2303.21.camel@rzhang1-mobl4>
 <20130225102526.GB12067@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130225102526.GB12067@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 11:25:26AM +0100, Borislav Petkov wrote:
> > has anybody checked if the patch at lkml.org/lkml/2012/12/30/47 fixes
> > the problem, without any other patch?
> 
> Ok, let me try it out.

Ok, doing a short test here proves successful. I'll run it the next days
too to make sure - it would be nice if people could confirm my test
results, though.

Tested-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
