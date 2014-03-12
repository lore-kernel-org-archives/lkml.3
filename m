Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaCLOfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:35:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47492 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560AbaCLOfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:35:21 -0400
Date: Wed, 12 Mar 2014 15:35:20 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH trivial 04/16] of: Improve grammar for of_alias_get_id()
 documentation
In-Reply-To: <CAMuHMdXM2ET281xPjsx0uZis9oC6=g2gvzmQo3m9_WHXwFBrqQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1403121534490.3690@pobox.suse.cz>
References: <1394533430-4746-1-git-send-email-geert@linux-m68k.org> <1394533430-4746-4-git-send-email-geert@linux-m68k.org> <CAL_JsqLtqpYzes6n4ujaGMnr0-7PhcJpUKc2KtTPigaChkjPkg@mail.gmail.com>
 <CAMuHMdXM2ET281xPjsx0uZis9oC6=g2gvzmQo3m9_WHXwFBrqQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014, Geert Uytterhoeven wrote:

> >> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> >> Cc: Grant Likely <grant.likely@linaro.org>
> >> Cc: devicetree@vger.kernel.org
> >
> > Acked-by: Rob Herring <robh@kernel.org>
> 
> Thanks!
> 
> > Did you want me to take this or it can go with the rest of the series?
> 
> I hope Jiri will take all of them through the trivial tree.

That's the plan -- I am just waiting a little bit more to (a) gather more 
acks (b) don't apply those that'll be picked by maintainers.

-- 
Jiri Kosina
SUSE Labs
