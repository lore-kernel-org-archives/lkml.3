Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853Ab3CDTZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 14:25:45 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:53291 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758773Ab3CDTZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 14:25:44 -0500
Date: Mon, 4 Mar 2013 20:25:43 +0100
From: Andreas Mohr <andi@lisas.de>
To: Borislav Petkov <bp@alien8.de>, Peter Feuerer <peter@piie.net>,
        Andreas Mohr <andi@lisas.de>, Zhang Rui <rui.zhang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Durgadoss R <durgadoss.r@intel.com>,
        Alexander Lam <azl@andrew.cmu.edu>
Subject: Re: [PATCH] acerhdf: Fix fan activation with new thermal governor
Message-ID: <20130304192543.GA24009@rhlx01.hs-esslingen.de>
References: <20130222111521.GA25473@pd.tnic>
 <1361647210-12983-1-git-send-email-bp@alien8.de>
 <20130224112851.GA19609@pd.tnic>
 <cone.1361706175.908398.1806.1000@galar>
 <20130224143452.GE19609@pd.tnic>
 <1361762514.2303.21.camel@rzhang1-mobl4>
 <20130225102526.GB12067@pd.tnic>
 <20130225121608.GC12067@pd.tnic>
 <20130304133410.GC22274@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130304133410.GC22274@pd.tnic>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 04, 2013 at 02:34:10PM +0100, Borislav Petkov wrote:
> Pjooiiing!

Heh, that was a broken one!
Rather well-deserved though - took too much time, been too busy.

> Andreas, Peter, can you guys give http://lkml.org/lkml/2012/12/30/47 a run?

Will fire up my HDD NOW.
About time to get all that stuff going anyway.
In need of a new less(?) buggy kernel anyway, since I suspect that stock 2.6.32
to be especially quirky with overly aggressive USB (SSD) resume timing...
(keep getting astonishing numbers of -71 timeouts on resume)


BTW, thanks very much to Zhang Rui for his timely tackling of the
acerhdf matter!

Andreas Mohr
