Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbaEEUzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:55:51 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37851 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbaEEUzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:55:50 -0400
Date: Mon, 5 May 2014 13:55:54 -0700
From: Olof Johansson <olof@lixom.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/2] ARM: multi_v7_defconfig: Select
 CONFIG_MACH_BERLIN_BG2Q
Message-ID: <20140505205554.GA29112@quad.lixom.net>
References: <1395430757-8677-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1395430757-8677-2-git-send-email-alexandre.belloni@free-electrons.com>
 <532CB266.6050800@gmail.com>
 <534D8B25.3070103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534D8B25.3070103@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 09:40:21PM +0200, Sebastian Hesselbarth wrote:
> On 03/21/2014 10:43 PM, Sebastian Hesselbarth wrote:
> > On 03/21/2014 08:39 PM, Alexandre Belloni wrote:
> >> Now that we support Berlin BG2Q, select CONFIG_MACH_BERLIN_BG2Q so
> >> that we can
> >> boot BG2Q based boards like the BG2Q DMP.
> >>
> >> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > 
> > Applied to berlin/soc, Thanks!
> 
> After talking to Arnd on IRC, I found out it is not my business
> taking patches for multi_v7_defconfig.
> 
> Instead of me taking it, you get my
> 
> Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> 

Applied, but next time please send any patch you want us to apply to
arm@kernel.org.

FWIW, it's usually how I distinguish between things to review if I have
time (personal email) and things that will need attention eventually
(arm@kernel.org). It also has the benefit of going to all current
maintainers of arm-soc without you having to worry about who it is. :)

-Olof
