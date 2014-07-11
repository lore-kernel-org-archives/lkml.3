Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbaGKN6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:58:23 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:45505 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbaGKN6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:58:20 -0400
Date: Fri, 11 Jul 2014 14:58:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: Re: No uart output on my snowball board
Message-ID: <20140711135813.GD2954@lee--X1>
References: <20140710223021.6e9c857f@gandalf.local.home>
 <CACRpkdZM5NECaPbFC1aGH2zD4T_8g9TYRy1HkbDVAQvjJs5E5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZM5NECaPbFC1aGH2zD4T_8g9TYRy1HkbDVAQvjJs5E5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Linus Walleij wrote:
> On Fri, Jul 11, 2014 at 4:30 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > commit a0998b8321eb5f53ef51924f5ab6c69237ac1025
> > Author: Lee Jones <lee.jones@linaro.org>
> > Date:   Thu Aug 22 16:18:56 2013 +0100
> >
> >     ARM: ux500: Remove UART support when booting without Device Tree
> >
> >     It's time to remove all ATAG support from ux500 and rely solely on
> >     Device Tree booting. This patch is part of that endeavour.
> >
> >     Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >     Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> I hate that I didn't spot the speling mistake in the subject,
> its ATAG support we're removing, not UART :-)

Now you're going coo-coo. :)

The subject line is fine.  Take a look at the patch.

> Anyway, I think you got enough hints on how we do this
> with appended devicetrees instead, Lee's snippet should
> work or check out this page that I also posted to your
> G+ post:
> http://www.df.lth.se/~triad/krad/ux00/

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
