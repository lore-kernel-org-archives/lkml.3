Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbaDXNJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:09:25 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:48065 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753723AbaDXNJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:09:23 -0400
Date: Thu, 24 Apr 2014 14:08:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zhiming Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 0/7] ARM: berlin: add pinctrl support
Message-ID: <20140424130823.GT26756@n2100.arm.linux.org.uk>
References: <1398268276-9696-1-git-send-email-antoine.tenart@free-electrons.com> <CACRpkdbT94HqVroM_0gSJJ8Q2+YaKXLwjFGMn+4SCa_PYiF19Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbT94HqVroM_0gSJJ8Q2+YaKXLwjFGMn+4SCa_PYiF19Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 02:52:20PM +0200, Linus Walleij wrote:
> - Why do hardware engineers seek to reinvent wheels like pin
>   controllers, GPIO and DMA engines all the time :-/

They think they have a rectangular pin cross-section which needs special
treatment to fit into the round hole in a turned-pin socket. :)

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
