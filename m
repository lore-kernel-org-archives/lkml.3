Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab3BGJEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 04:04:41 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48852 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3BGJEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 04:04:31 -0500
Date: Thu, 7 Feb 2013 10:04:21 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: John Stultz <johnstul@us.ibm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] clocksource: dbx500-prcmu: use relaxed readl variant
Message-ID: <20130207090421.GA21658@balto.lan>
References: <1358770172-30125-1-git-send-email-fabio.baltieri@linaro.org>
 <20130121122203.GA30289@balto.lan>
 <CACRpkdacW89oq+yyjayY2674UGPdnnHS5veQsn2DaZ4-nao1Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdacW89oq+yyjayY2674UGPdnnHS5veQsn2DaZ4-nao1Pg@mail.gmail.com>
X-Operating-System: Linux balto 3.8.0-rc3-00668-g55706d3 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 11:16:19AM +0100, Linus Walleij wrote:
> On Mon, Jan 21, 2013 at 1:22 PM, Fabio Baltieri
> <fabio.baltieri@linaro.org> wrote:
> > On Mon, Jan 21, 2013 at 01:09:31PM +0100, Fabio Baltieri wrote:
> >> From: Rabin Vincent <rabin.vincent@stericsson.com>
> >>
> >> Modify clksrc_dbx500_prcmu_read to replace readl() with readl_relaxed().
> >> This speeds up calls to the function by about 40%.
> >
> > Hello John,
> >
> > these two patches may go in the existing ux500 clksrc branch
> > together with the nomadik-mtu's patches queued up some time ago.
> >
> > Can I have your Acked-by for that?
> 
> Actually now when I look at it these changes are fully orthogonal
> to the other stuff, so these two should just go in through John's
> timer tree as usual.
> 
> John?

Hi John,

any feedback from this two patches?

Thanks,
Fabio

-- 
Fabio Baltieri
