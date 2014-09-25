Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaIYO5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:57:12 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:64628 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbaIYO5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:57:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-arch@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-ia64@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, sparclinux@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v4 0/8] asm-generic/io.h overhaul
Date: Thu, 25 Sep 2014 16:56:53 +0200
Message-ID: <3399763.VZ83zCGta1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140924060419.GA20253@ulmo>
References: <1407925738-26170-1-git-send-email-thierry.reding@gmail.com> <20140825112630.GA4163@ulmo.nvidia.com> <20140924060419.GA20253@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:cG0nmYsm+/lqYL+5iEOB16olXnCs8D8JsPEWfDbp/Xw
 zqs/YOw7Hl9NCD0DhRK2PauvTRj16bvHpwhKYaxz/DBr1iUevo
 VKBIkE9P0vzL2Fu5V1dB2dNpP3CjhI1BRniV4o8KpmLrZ+YQ5z
 ZDmKmGOKBxVOTuwYkYSIBHo4YHnBjwNbHq2Zvw9MkXSLD3ShTC
 3goQXtEyx0XarJEC5hOGqiVft8GOFcZ5v7K05Rv58CAZteN4wQ
 LvZAA5EJ5Q8QruuiExv5KGs+dPRjXYLWnQns8UboKeCC0H8lIR
 5jO2xH2XdGBhTTlKmBbyO6mYI4J3PHn/SKrNLORAWB2BOMgE9W
 BRxoOKcplIpMlKXAog4k=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2014 08:04:21 Thierry Reding wrote:
> > 
> > Arnd, do you think this looks good to take for test-driving in
> > linux-next?
> 
> Ping?
> 

I've put it all into the asm-generic tree, and Will's patches on top.
Unless I get complaints, I plan to submit them all for 3.18.

	Arnd
