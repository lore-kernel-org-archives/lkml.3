Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab3IVVcy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 17:32:54 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:44186 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3IVVcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 17:32:53 -0400
MIME-Version: 1.0
In-Reply-To: <SNT146-W710244DBE31ABDA9A6D398C82C0@phx.gbl>
References: <CACnwZYfz_3AJc+cL4rBP1rhGWAmk+V18C3EOJtuVx2eRjtb9LA@mail.gmail.com>
	<SNT146-W710244DBE31ABDA9A6D398C82C0@phx.gbl>
Date: Sun, 22 Sep 2013 18:32:52 -0300
Message-ID: <CACnwZYfRUDWF+JC_Ob8TomGjf7iNSJcJ_B43Bbe1OJfSAOqeXA@mail.gmail.com>
Subject: Re: throuble installing kernel
From: Thiago Farina <tfransosi@gmail.com>
To: Varad Gautam <varadgautam@live.com>
Cc: linux list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Varad,

On Sun, Sep 22, 2013 at 6:10 PM, Varad Gautam <varadgautam@live.com> wrote:
>> What I'm doing wrong? I want it to use my .config, I don't want to
>> answer all the thousands questions it prompts me (I don't know all the
>> options to know what should go and what should not, hence I want it to
>> use my current configuration).
>
> Hi! If you want to use the existing .config file, you should use `make oldconfig` instead. It may still prompt for options not in the file; to use the default ones, just do `yes "" | make oldconfig`.
Yeah, it still prompts me, which is annoying. But anyway, I'll try
your suggestion.

Thanks!

--
Thiago Farina
