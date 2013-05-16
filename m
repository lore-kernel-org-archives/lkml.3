Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab3EPIUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 04:20:06 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:57933 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab3EPIUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 04:20:02 -0400
Message-ID: <519496AC.1070809@free-electrons.com>
Date: Thu, 16 May 2013 10:19:56 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jamie Iles <jamie@jamieiles.com>
CC: Michal Simek <michal.simek@xilinx.com>,
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
References: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com> <1368545933-7430-5-git-send-email-maxime.ripard@free-electrons.com> <20130514162046.GA16346@page>
In-Reply-To: <20130514162046.GA16346@page>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jamie,

Le 14/05/2013 18:20, Jamie Iles a écrit :
> Hi Maxime,
> 
> Thanks for this, I'll add it to my tree.  I've modified it slightly to 
> kill off the other irq includes, hopefully that's okay with you.

Yes, I was pretty conservative since I was not familiar with most of the
code, but yes, I'm fine with the changes.

Thank you,
Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
