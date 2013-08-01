Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3HAHbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:31:40 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:54096 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab3HAHbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:31:35 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYwNoqQieinZ0Vyji-hsY0UqTHMDSgCL6Y-7M0bxQHPwQ@mail.gmail.com>
References: <1373972146-12133-1-git-send-email-sonic.adi@gmail.com>
	<CAJxxZ0OXC46Xcgb+_g00D0NJ_NiHE0eQm+Dg6ze1_93mZqkQPw@mail.gmail.com>
	<CACRpkdYwNoqQieinZ0Vyji-hsY0UqTHMDSgCL6Y-7M0bxQHPwQ@mail.gmail.com>
Date: Thu, 1 Aug 2013 15:31:34 +0800
Message-ID: <CAJxxZ0NHVRzHcFqy6V5_MzbRS9Dz8R5eLp6Oz+DF6SYLWB8r8w@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: ADI PIN control driver for the GPIO
 controller on bf54x and bf60x.
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>, Steven Miao <realmz6@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Jul 30, 2013 at 12:47 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Fri, Jul 26, 2013 at 6:57 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:
>
>> Could you please comment on this patch set? It is based on your former comments.
>
> I'll get to it. I'm pretty choked right now and actually trying to have
> some vacation at the same time.
>
> In the meantime, after glancing over and noting prolific use of the
> unlikely() macro, please read the following articles:
> http://lwn.net/Articles/70473/
> http://lwn.net/Articles/420019/
>

These articles say the directives should be rarely used. Do you
suggest to remove them from the patch?

Regards,

Sonic
