Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaCHLuw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 06:50:52 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:37423 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaCHLuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 06:50:50 -0500
X-Auth-Info: Esxst9IRlkXAn1Z/+cRmpgfHda42Z3ljTLrxU602vjQ=
Date: Sat, 8 Mar 2014 12:50:45 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Tien Hock Loh <thloh@altera.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        "lftan@altera.com" <lftan@altera.com>,
        Tien Hock Loh <thloh.linux@gmail.com>
Subject: Re: [PATCH V7 1/1] drivers/gpio: Altera soft IP GPIO driver and
 devicetree binding
Message-ID: <20140308115045.GL3327@book.gsilab.sittig.org>
References: <1393842463-5206-1-git-send-email-thloh@altera.com>
 <CACRpkdbwKuaTucbHbuXsKpRAg+kN27K6uN212TT1-h8wxY9YzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbwKuaTucbHbuXsKpRAg+kN27K6uN212TT1-h8wxY9YzA@mail.gmail.com>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 11:31 +0800, Linus Walleij wrote:
> 
> On Mon, Mar 3, 2014 at 6:27 PM,  <thloh@altera.com> wrote:
> 
> > From: Tien Hock Loh <thloh@altera.com>
> >
> > Add driver support for Altera GPIO soft IP, including interrupts and I/O.
> > Tested on Altera CV SoC board using dipsw and LED using LED framework.
> >
> > Signed-off-by: Tien Hock Loh <thloh@altera.com>
> 
> Can I get some ACKs on this? Like from Gerhard, DT folks?
> 
> Or is there still more things to do?

Sorry, had flagged the patch for review, but did not get around
to respond earlier.  No ACK from me for v7 as it is.

Am I supposed to provide ACKs at all, given that I'm a reviewer
and fellow developer.  I always understood that Acked-By is
something more formal, where one maintainer signals to another
maintainer that it's OK to go though a different tree.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
