Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab3IMJcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 05:32:33 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:33037 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630Ab3IMJc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 05:32:27 -0400
MIME-Version: 1.0
In-Reply-To: <CACW0xKXOKJXW+5m7JirKbsj4Em4SbVV0NeyK2x88x46dfJ4akw@mail.gmail.com>
References: <cover.1376600922.git.yann.morin.1998@free.fr>
	<83e8b90e1d2cc5ff5d2443f2486c2d786a4997ce.1376600922.git.yann.morin.1998@free.fr>
	<CACRpkdYjzGwaV0Eg5KZ7W_9YYkyiAXDc-9oagU49XWJUooVKdQ@mail.gmail.com>
	<CACW0xKXOKJXW+5m7JirKbsj4Em4SbVV0NeyK2x88x46dfJ4akw@mail.gmail.com>
Date: Fri, 13 Sep 2013 11:32:26 +0200
Message-ID: <CACRpkdY8nLnH5RG94kXuWBv=qb6osRSvGRODy3ywKDdHSGae5w@mail.gmail.com>
Subject: Re: [PATCH 2/4] scripts/config: use sed's POSIX interface
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Cl=E9ment_Chauplannaz?= <chauplac@gmail.com>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 10:38 AM, Clément Chauplannaz
<chauplac@gmail.com> wrote:

> Thank you for this report. I was able to reproduce this bug and fix it.

Thanks! Tested and works fine.

> My previous commit changed the separator between sed's substitute
> command and its parameters, from ':' to '/'. The latter conflicted
> with the slashes found in the value of variable CMDLINE, as provided
> in your email.

Hm it could actually be useful to be able to have colons in a CMDLINE,
I wonder if we can think about some better separator ... oh well that
is another issue, all old scripts work now anyway.

Yours,
Linus Walleij
