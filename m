Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab3IMJyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 05:54:45 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:60220 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718Ab3IMJyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 05:54:37 -0400
References: <cover.1376600922.git.yann.morin.1998@free.fr> <83e8b90e1d2cc5ff5d2443f2486c2d786a4997ce.1376600922.git.yann.morin.1998@free.fr> <CACRpkdYjzGwaV0Eg5KZ7W_9YYkyiAXDc-9oagU49XWJUooVKdQ@mail.gmail.com> <CACW0xKXOKJXW+5m7JirKbsj4Em4SbVV0NeyK2x88x46dfJ4akw@mail.gmail.com> <CACRpkdY8nLnH5RG94kXuWBv=qb6osRSvGRODy3ywKDdHSGae5w@mail.gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <CACRpkdY8nLnH5RG94kXuWBv=qb6osRSvGRODy3ywKDdHSGae5w@mail.gmail.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-Id: <B58F4964-E48A-4D56-ABEE-C8E9514B2651@gmail.com>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (10B350)
From: =?utf-8?Q?Cl=C3=A9ment_Chauplannaz?= <chauplac@gmail.com>
Subject: Re: [PATCH 2/4] scripts/config: use sed's POSIX interface
Date: Fri, 13 Sep 2013 11:54:31 +0200
To: Linus Walleij <linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 13, 2013, at 11:32 AM, Linus Walleij <linus.walleij@linaro.org> wrote:

> On Fri, Sep 13, 2013 at 10:38 AM, Clément Chauplannaz
> <chauplac@gmail.com> wrote:
> 
>> Thank you for this report. I was able to reproduce this bug and fix it.
> 
> Thanks! Tested and works fine.
Glad to read the patch solves your issue. Thanks for the quick feedback!
> 
>> My previous commit changed the separator between sed's substitute
>> command and its parameters, from ':' to '/'. The latter conflicted
>> with the slashes found in the value of variable CMDLINE, as provided
>> in your email.
> 
> Hm it could actually be useful to be able to have colons in a CMDLINE,
> I wonder if we can think about some better separator ... oh well that
> is another issue, all old scripts work now anyway.
Indeed config script may not work with all possible string values. My first concern for now was to fallback to previous interface. We may look into hardening the script later on.

Best regards,
Clement Chauplannaz