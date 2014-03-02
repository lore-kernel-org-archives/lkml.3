Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaCBVNa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 16:13:30 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:59542 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaCBVN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 16:13:28 -0500
Date: Sun, 2 Mar 2014 22:13:28 +0100
From: Andreas Mohr <andi@lisas.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Dave Jones <davej@redhat.com>, Andreas Mohr <andi@lisas.de>,
        Chris Bainbridge <chris.bainbridge@gmail.com>,
        Dennis Mungai <dmngaie@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
Message-ID: <20140302211328.GA20674@rhlx01.hs-esslingen.de>
References: <20140228140043.GA12157@debian.local>
 <20140302205619.GA8676@rhlx01.hs-esslingen.de>
 <20140302210201.GA31948@redhat.com>
 <20140302210419.GB25710@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140302210419.GB25710@pd.tnic>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2014 at 10:04:19PM +0100, Borislav Petkov wrote:
> On Sun, Mar 02, 2014 at 04:02:01PM -0500, Dave Jones wrote:
> > It would be a considerable amount of work to make it a runtime thing.
> > Ten years ago, maybe it would be worth the effort perhaps, but I'd
> > suggest just letting 32-bit slowly die instead of doing dramatic
> > overhauls that will no doubt introduce a bunch of regressions in code
> > that's been notoriously awful to debug issues in during the past.
> 
> Amen!

Did I just smell two or three historically burnt fingers? ;)

While that was slightly disheartening, thanks for the very fast clarification,
Dave et al.!

Andreas Mohr
