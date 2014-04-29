Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbaD2KeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 06:34:08 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34490 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004AbaD2KeG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 06:34:06 -0400
Date: Tue, 29 Apr 2014 11:34:00 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v6 3/5] devicetree: bindings: Document Krait cache error
 interrupts
Message-ID: <20140429103400.GB22015@e102568-lin.cambridge.arm.com>
References: <1396641450-12854-1-git-send-email-sboyd@codeaurora.org>
 <1396641450-12854-4-git-send-email-sboyd@codeaurora.org>
 <20140408153925.GJ30077@pd.tnic>
MIME-Version: 1.0
In-Reply-To: <20140408153925.GJ30077@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 29 Apr 2014 10:34:16.0381 (UTC) FILETIME=[921026D0:01CF6396]
X-MC-Unique: 114042911340400801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 04:39:25PM +0100, Borislav Petkov wrote:
> On Fri, Apr 04, 2014 at 12:57:28PM -0700, Stephen Boyd wrote:
> > The Krait L1/L2 error reporting hardware is made up a per-CPU
> > interrupt for the L1 cache and a SPI interrupt for the L2.
> > 
> > Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Kumar Gala <galak@codeaurora.org>
> > Cc: <devicetree@vger.kernel.org>
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > ---
> >  Documentation/devicetree/bindings/arm/cache.txt | 48 ++++++++++++++++++++++++-
> >  1 file changed, 47 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/arm/cache.txt b/Documentation/devicetree/bindings/arm/cache.txt
> > index b90fcc7c53cf..d7357e777399 100644
> > --- a/Documentation/devicetree/bindings/arm/cache.txt
> > +++ b/Documentation/devicetree/bindings/arm/cache.txt
> 
> Right, that's http://www.spinics.net/lists/arm-kernel/msg308540.html
> 
> So whoever picks those patches up, Lorenzo's doc needs to be in his tree
> first too.

Sorry for the delay in replying. Those cache bindings need an ACK to get
merged, and were introduced so that idle states can retrieve power domain
information for caches. I am going to revive the idle bindings thread
to see what we can/should merge of these bindings as things stand, I
really hope this won't block the series any further, otherwise we can
rework the patches so that this series can get in first, or simplify my
series to allow both to get merged as soon as possible without compromising
future requirements.

Thanks,
Lorenzo

