Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3JaL5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 07:57:23 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:59363 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab3JaL5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 07:57:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAK2Ky6x+wiwa5F6+K+Ee0y_TkbG-oA3tDBWp+2wO8mPqSTyQnA@mail.gmail.com>
References: <CAK2Ky6x+wiwa5F6+K+Ee0y_TkbG-oA3tDBWp+2wO8mPqSTyQnA@mail.gmail.com>
Date: Thu, 31 Oct 2013 12:57:19 +0100
Message-ID: <CAFLxGvy=pQZBmLuhnY2om-Ypek-B=qTeu_r9P1cgRHcyLxbg-g@mail.gmail.com>
Subject: Re: A simple question of a linux kernel beginner
From: Richard Weinberger <richard.weinberger@gmail.com>
To: =?UTF-8?B?6Z+p56OK?= <bonben1989@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 12:31 PM, 韩磊 <bonben1989@gmail.com> wrote:
> May I can use  the ''double" as a  basic variables?
>
> When I define the "double" as a function return type in linux kernel,the error
> is "error: SSE register return with SSE disabled".
>
> How to fix it??

Don't do it. :)
In kernel land we don't want FPU stuff because it slows the mode switch down.
If you *really* need to use the FPU look how the raid6 or crypto code does.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
