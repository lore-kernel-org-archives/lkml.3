Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab3E0MQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:16:38 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:34420 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179Ab3E0MQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:16:36 -0400
Date: Mon, 27 May 2013 14:16:27 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH] ARM: ux500: select SND_SOC_UX500 for ux500
Message-ID: <20130527121627.GA29935@balto.lan>
References: <1369402093-27817-1-git-send-email-fabio.baltieri@linaro.org>
 <CACRpkdbB7KjzUCf72gqN3ooiWYYkaaPrZUEDeG8HuLk3pTB72A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbB7KjzUCf72gqN3ooiWYYkaaPrZUEDeG8HuLk3pTB72A@mail.gmail.com>
X-Operating-System: Linux balto 3.10.0-rc2-00332-g17fdfd0 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 01:44:38PM +0200, Linus Walleij wrote:
> On Fri, May 24, 2013 at 3:28 PM, Fabio Baltieri
> <fabio.baltieri@linaro.org> wrote:
> 
> > Enable ux500 specific ALSA SoC drivers by default on u8500_defconfig.
> >
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> 
> Thanks, patch applied to my defconfig branch.
> 
> Now I can finally use the Snowball board to run sidplay.

Glad to be of help! :-)

Fabio

-- 
Fabio Baltieri
