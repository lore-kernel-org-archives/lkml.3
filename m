Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762903Ab3ECQzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 12:55:36 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:62717 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab3ECQze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 12:55:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130503185148.600554bd@endymion.delvare>
References: <CACxGe6vr1kh2yqnG6kpASBGDUQrC7taBu00VWu6VG+qCO2u9QA@mail.gmail.com>
 <CA+55aFw9fbZBiZDC25j4A50NmsYbpwV-wUfWMpE_D7bEXQ-XVg@mail.gmail.com> <20130503185148.600554bd@endymion.delvare>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 3 May 2013 17:55:14 +0100
X-Google-Sender-Auth: uZ1zbEYJF6_0V_ZtDJ04bMglBDI
Message-ID: <CACxGe6sG6DQKTXDXmb71VRTaHWaUXBc3Zs=-wHwNWVEX44e3ow@mail.gmail.com>
Subject: Re: [git pull] GPIO for v3.10
To: Jean Delvare <khali@linux-fr.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Marek Vasut <marex@denx.de>, Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <samuel@sortiz.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 5:51 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Linus,
>
> On Fri, 3 May 2013 09:14:44 -0700, Linus Torvalds wrote:
> The real problem here is that two patches which depended on each other
> went to you through 2 different maintainer trees (mfd maintained by
> Samuel Ortiz and gpio maintained by Grant L. & Linus W.), and the git
> pull requests reached you in the wrong order. That doesn't make us all
> irresponsible and lame contributors/maintainers, does it?

Actually, it does make us (me) wrong and irresponsible. It should
never have happened because dependencies should never be committed to
different trees.

g.
