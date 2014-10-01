Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283AbaJAK1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 06:27:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49293 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaJAK1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 06:27:07 -0400
Date: Wed, 1 Oct 2014 12:27:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Johannes Thumshirn <johannes.thumshirn@men.de>, dougthompson@xmission.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] EDAC: remove deprecated IRQF_DISABLED
Message-ID: <20141001102701.GB18271@pd.tnic>
References: <1381641477-7373-1-git-send-email-michael.opdenacker@free-electrons.com>
 <20131014095602.GA14274@jtlinux>
 <5316B065.7070104@free-electrons.com>
 <20140305064915.GA28317@pd.tnic>
 <542BD4DC.40900@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <542BD4DC.40900@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 12:18:04PM +0200, Michael Opdenacker wrote:
> > https://git.kernel.org/cgit/linux/kernel/git/bp/bp.git/commit/?id=e245e3b25f9ef33b166f0f01d19d6418f52ae726
> >
> > ?
> >
> > Its on its way upstream.
> 
> It didn't get merged indeed.

Did you actually check?

$ git describe e245e3b25f9ef33b166f0f01d19d6418f52ae726
v3.14-rc1-4-ge245e3b25f9e

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
