Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbaCBVE0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 16:04:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47494 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbaCBVEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 16:04:25 -0500
Date: Sun, 2 Mar 2014 22:04:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Jones <davej@redhat.com>
Cc: Andreas Mohr <andi@lisas.de>,
        Chris Bainbridge <chris.bainbridge@gmail.com>,
        Dennis Mungai <dmngaie@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
Message-ID: <20140302210419.GB25710@pd.tnic>
References: <20140228140043.GA12157@debian.local>
 <20140302205619.GA8676@rhlx01.hs-esslingen.de>
 <20140302210201.GA31948@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140302210201.GA31948@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2014 at 04:02:01PM -0500, Dave Jones wrote:
> It would be a considerable amount of work to make it a runtime thing.
> Ten years ago, maybe it would be worth the effort perhaps, but I'd
> suggest just letting 32-bit slowly die instead of doing dramatic
> overhauls that will no doubt introduce a bunch of regressions in code
> that's been notoriously awful to debug issues in during the past.

Amen!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
