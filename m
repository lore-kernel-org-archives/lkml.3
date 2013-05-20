Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab3ETWmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 18:42:21 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:56692 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab3ETWmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 18:42:18 -0400
Date: Mon, 20 May 2013 23:42:14 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Jamie Iles <jamie@jamieiles.com>, Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Christian Daudt <csd@broadcom.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>, Barry Song <baohua.song@csr.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 04/20] ARM: picoxcell: Remove init_irq declaration in
 machine description
Message-ID: <20130520224214.GA4659@page>
References: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
 <1368545933-7430-5-git-send-email-maxime.ripard@free-electrons.com>
 <20130514162046.GA16346@page>
 <519496AC.1070809@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <519496AC.1070809@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 10:19:56AM +0200, Maxime Ripard wrote:
> Hi Jamie,
> 
> Le 14/05/2013 18:20, Jamie Iles a écrit :
> > Hi Maxime,
> > 
> > Thanks for this, I'll add it to my tree.  I've modified it slightly to 
> > kill off the other irq includes, hopefully that's okay with you.
> 
> Yes, I was pretty conservative since I was not familiar with most of the
> code, but yes, I'm fine with the changes.

Thanks Maxime, applied to picoxcell-next.

Jamie
