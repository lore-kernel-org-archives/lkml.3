Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188AbaEWVzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:55:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57500 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750995AbaEWVzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:55:48 -0400
Date: Fri, 23 May 2014 23:55:44 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Olof Johansson <olof@lixom.net>,
        arm@kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: DT for 3.16 at91-dt3 #3
Message-ID: <20140523215544.GI13642@piout.net>
References: <1400775895-31183-1-git-send-email-nicolas.ferre@atmel.com>
 <201405232327.52312.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201405232327.52312.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/2014 at 23:27:51 +0200, Arnd Bergmann wrote :
> On Thursday 22 May 2014, Nicolas Ferre wrote:
> > Another AT91 DT pull-request for 3.16. This one is the conversion of two more
> > SoC to Common Clock Framework (aka CCF). I identified it as a "DT" pull-request
> > but it modifies slightly a couple of files in mach-at91 (use of a configuration
> > option).
> 
> Four done, four more to go? Nice progress!
> 

I'm on it ;) I actually have two more almost ready but I will submit the
remaining four for 3.17. I don't think this is urgent enough to rush it
and I'd like to test it enough before we start removing the old clock
implementation and board files.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
