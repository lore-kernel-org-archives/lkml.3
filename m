Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbaCBVC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 16:02:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbaCBVC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 16:02:27 -0500
Date: Sun, 2 Mar 2014 16:02:01 -0500
From: Dave Jones <davej@redhat.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Chris Bainbridge <chris.bainbridge@gmail.com>,
        Dennis Mungai <dmngaie@gmail.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
Message-ID: <20140302210201.GA31948@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andreas Mohr <andi@lisas.de>,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	Dennis Mungai <dmngaie@gmail.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <20140228140043.GA12157@debian.local>
 <20140302205619.GA8676@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140302205619.GA8676@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2014 at 09:56:19PM +0100, Andreas Mohr wrote:

 > (BTW, would it be possible to transform Linux's PAE support into
 > boot-config or even fully runtime-detectable boot switching to
 > (non-)PAE, similar to or exceeding what XP offers with its static
 > boot-time flag?
 > Last time I checked PAE support config defines were spread over ~ 40
 > kernel source files though :-((()

It would be a considerable amount of work to make it a runtime thing.
Ten years ago, maybe it would be worth the effort perhaps, but I'd
suggest just letting 32-bit slowly die instead of doing dramatic overhauls
that will no doubt introduce a bunch of regressions in code that's been
notoriously awful to debug issues in during the past.

	Dave

