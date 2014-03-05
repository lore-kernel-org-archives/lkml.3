Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaCEGtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 01:49:22 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54596 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbaCEGtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 01:49:20 -0500
Date: Wed, 5 Mar 2014 07:49:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Johannes Thumshirn <johannes.thumshirn@men.de>, dougthompson@xmission.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] EDAC: remove deprecated IRQF_DISABLED
Message-ID: <20140305064915.GA28317@pd.tnic>
References: <1381641477-7373-1-git-send-email-michael.opdenacker@free-electrons.com>
 <20131014095602.GA14274@jtlinux>
 <5316B065.7070104@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5316B065.7070104@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 06:04:37AM +0100, Michael Opdenacker wrote:
> My patch still applies to 3.14-rc5, which means that mpc85xx_edac is
> still there.
> 
> I'd like to get rid of this patch for good ;)

Something like that, right:

https://git.kernel.org/cgit/linux/kernel/git/bp/bp.git/commit/?id=e245e3b25f9ef33b166f0f01d19d6418f52ae726

?

Its on its way upstream.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
