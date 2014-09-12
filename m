Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaILRgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:36:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56481 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751300AbaILRgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:36:53 -0400
Date: Fri, 12 Sep 2014 19:36:49 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 8/8] ARM: at91: document Atmel SMART compatibles
Message-ID: <20140912173648.GA26281@piout.net>
References: <1410536587-24607-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1410536587-24607-9-git-send-email-alexandre.belloni@free-electrons.com>
 <20140912184754.546b26cf@e6520eb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140912184754.546b26cf@e6520eb>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/09/2014 at 18:47:54 +0200, Eric Bénard wrote :
> > +
> > +
> > +In addition, the above compatible shall be extended with the specific
> > +SoC and board used. Currently known SoC compatibles are:
> > +    "marvell,berlin2"      for Marvell Armada 1500 (BG2, 88DE3100),
> > +    "marvell,berlin2cd"    for Marvell Armada 1500-mini (BG2CD, 88DE3005)
> > +    "marvell,berlin2ct"    for Marvell Armada ? (BG2CT, 88DE????)
> > +    "marvell,berlin2q"     for Marvell Armada 1500-pro (BG2Q, 88DE3114)
> > +    "marvell,berlin3"      for Marvell Armada ? (BG3, 88DE????)
> > +
> > +
> maybe remove those 10 last lines ;-)
> 

I don't even know what they are doing here, I probably misclicked in the
wrong window at some point ;)

Thanks!

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
