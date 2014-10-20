Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaJTSSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:18:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbaJTSSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:18:15 -0400
Date: Mon, 20 Oct 2014 20:17:55 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 5/8] perf, tools: Support source line numbers in annotate
Message-ID: <20141020181755.GA5851@krava.brq.redhat.com>
References: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
 <1411774636-6870-6-git-send-email-andi@firstfloor.org>
 <20141020180605.GC9913@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020180605.GC9913@krava.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 08:06:05PM +0200, Jiri Olsa wrote:

SNIP

> > +		if (dl->line_nr && annotate_browser__opts.show_linenr)
> > +			printed = scnprintf(bf, sizeof(bf), "%*s %-5d ",
> > +					ab->addr_width, " ", dl->line_nr);
> > +		else
> > +			printed = scnprintf(bf, sizeof(bf), "%*s  ",
> >  				    ab->addr_width, " ");
> >  		slsmg_write_nstring(bf, printed);
> >  		slsmg_write_nstring(dl->line, width - printed - pcnt_width + 1);
> > @@ -733,6 +738,7 @@ static int annotate_browser__run(struct annotate_browser *browser,
> >  		"o             Toggle disassembler output/simplified view\n"
> >  		"s             Toggle source code view\n"
> >  		"/             Search string\n"
> > +		"k	       Toggle line numbers\n"
> 
> extra tab --------^^^^^^ making the text misaligned in the help box

also by pressing 'k' the current line jumps to
the hottest line, which does not seem right

jirka
