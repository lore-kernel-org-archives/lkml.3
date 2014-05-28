Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbaE1Ipq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:45:46 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:36593 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572AbaE1Ipo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:45:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140528083649.GB10803@lee--X1>
References: <1401248417-10146-1-git-send-email-sachin.kamat@linaro.org>
	<20140528083649.GB10803@lee--X1>
Date: Wed, 28 May 2014 14:15:43 +0530
Message-ID: <CAK9yfHwHO_WPaGqJLVxOZrzFCRqBKi+zJPF2-8cDPokcdkb2dA@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: ux500: Staticize ux500_soc_attr
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On 28 May 2014 14:06, Lee Jones <lee.jones@linaro.org> wrote:
> On Wed, 28 May 2014, Sachin Kamat wrote:
>
>> 'ux500_soc_attr' is local to this file. While at it also make it
>> const to match the argument list of device_create_file.
>
> What's going on Sachin?  I Acked v2 of this patch an hour ago, yet
> you've resent it as a v1 and without the Ack?

Actually I posted v2 twice almost immediately. The first time I forgot to
CC LKML as requested by you. Sorry for the confusion.


-- 
With warm regards,
Sachin
