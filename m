Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab3GQQK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:10:58 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:43960 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab3GQQK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:10:56 -0400
Date: Wed, 17 Jul 2013 18:10:51 +0200
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, jolsa@redhat.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix 'make tools/perf'
Message-ID: <20130717161051.GJ8731@rric.localhost>
References: <1370964158-4135-1-git-send-email-rric@kernel.org>
 <tip-107de3724eff5a6fa6474a4d2aa5460b63749ebf@git.kernel.org>
 <20130712093909.GD8731@rric.localhost>
 <20130716145036.GH8731@rric.localhost>
 <20130717153118.GC2071@ghostprotocols.net>
 <20130717154001.GA4454@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130717154001.GA4454@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.07.13 17:40:01, Borislav Petkov wrote:
> On Wed, Jul 17, 2013 at 12:31:18PM -0300, Arnaldo Carvalho de Melo wrote:
> > Humm, probably it will look at the top level 'install' target? There
> > was some discussion about this, right? Can you refresh my mind?

Yeah, this

 make tools/perf install

does 2 different things and not what you want.

> 
> that's
> 
> make tools/perf_install.
> 
> which goes to the target in tools/Makefile as the rest of the tools
> there.

But Boris' one should work.

Thanks,

-Robert
