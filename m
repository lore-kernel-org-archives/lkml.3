Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbaGDQKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 12:10:04 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:48406 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbaGDQKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 12:10:03 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1407041615280.8188@nippy.intranet>
References: <1404351693-5588-1-git-send-email-xerofoify@gmail.com>
	<alpine.LNX.2.00.1407041125060.15901@nippy.intranet>
	<CAPDOMVhvuvWesMev-5dOFA78Sf67o0kUCXR2VkdhE-xeiYQ=6w@mail.gmail.com>
	<alpine.LNX.2.00.1407041615280.8188@nippy.intranet>
Date: Fri, 4 Jul 2014 12:10:01 -0400
Message-ID: <CAPDOMVh4V_JLdXoL4SH6nWFwxnjXENWbyApkioK8eNE892iZ9A@mail.gmail.com>
Subject: Re: [PATCH] m68k: Remove FIXME comment in file sun3_pgalloc.h
From: Nick Krause <xerofoify@gmail.com>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: sammy@sammy.net, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very well then seems I should resend this patch removing the define
line as it seems to have no use
in this file.
Cheers Nick

On Fri, Jul 4, 2014 at 2:19 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
>
> On Fri, 4 Jul 2014, Nick Krause wrote:
>
>> What are these two lines for them another compile issue?
>
> I don't see why those two lines are important.
>
>> >> -/* FIXME - when we get this compiling */
>> >>  /* erm, now that it's compiling, what do we do with it? */
>> >>  #define _KERNPG_TABLE 0
>
> Presumably it is the third line that the "FIXME" refers to.
>
> I didn't write this code, but obviously it isn't supposed to be read as
>
> /* FIXME - this comment needs to be deleted */
>
> --
