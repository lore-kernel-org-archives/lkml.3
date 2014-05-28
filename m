Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbaE1JCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:02:50 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:59912 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbaE1JCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:02:46 -0400
Date: Wed, 28 May 2014 10:02:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] ARM: ux500: Staticize ux500_soc_attr
Message-ID: <20140528090241.GC10803@lee--X1>
References: <1401248417-10146-1-git-send-email-sachin.kamat@linaro.org>
 <20140528083649.GB10803@lee--X1>
 <CAK9yfHwHO_WPaGqJLVxOZrzFCRqBKi+zJPF2-8cDPokcdkb2dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK9yfHwHO_WPaGqJLVxOZrzFCRqBKi+zJPF2-8cDPokcdkb2dA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 28 May 2014 14:06, Lee Jones <lee.jones@linaro.org> wrote:
> > On Wed, 28 May 2014, Sachin Kamat wrote:
> >
> >> 'ux500_soc_attr' is local to this file. While at it also make it
> >> const to match the argument list of device_create_file.
> >
> > What's going on Sachin?  I Acked v2 of this patch an hour ago, yet
> > you've resent it as a v1 and without the Ack?
> 
> Actually I posted v2 twice almost immediately. The first time I forgot to
> CC LKML as requested by you. Sorry for the confusion.

Okay, I see.  Thanks for clarifying.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
