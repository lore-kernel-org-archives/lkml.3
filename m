Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935816Ab3DITNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:13:04 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:39815 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935459Ab3DITNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:13:02 -0400
Date: Tue, 9 Apr 2013 20:12:56 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 7/8] dmaengine: ste_dma40: Use the BIT macro to replace
 ugly '(1 << x)'s
Message-ID: <20130409191256.GG25316@gmail.com>
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org>
 <1365532783-27425-7-git-send-email-lee.jones@linaro.org>
 <CAHLZz133b6kydVwh0_Cn2yg-Q_MeUF+Z-7+CMY7TkB7KK2ssAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHLZz133b6kydVwh0_Cn2yg-Q_MeUF+Z-7+CMY7TkB7KK2ssAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Apr 2013, Harvey Harrison wrote:

> On Tue, Apr 9, 2013 at 11:39 AM, Lee Jones <lee.jones@linaro.org> wrote:
> >
> > The aim is to make the code that little more readable.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> 
> >
> >  #define MAX(a, b) (((a) < (b)) ? (b) : (a))
> 
> Not part of your patch, but probably a good idea to switch to the
> generic MAX macro, this
> one is evaluating its args twice.

Sure, thanks for the heads-up.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
