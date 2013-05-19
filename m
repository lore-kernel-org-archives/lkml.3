Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab3ESOZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 10:25:39 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:40839 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3ESOZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 10:25:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75Ver1mop0cV5T3BfifeMshtxDonDeXrp8mg-WY8jEBL_VQ@mail.gmail.com>
References: <1368971300-14442-1-git-send-email-bbonev@ipacct.com> <CAHp75Ver1mop0cV5T3BfifeMshtxDonDeXrp8mg-WY8jEBL_VQ@mail.gmail.com>
From: Boian Bonev <bbonev@ipacct.com>
Date: Sun, 19 May 2013 17:25:08 +0300
X-Google-Sender-Auth: FPzp69tvzH7MiRAUbVO357TpwJQ
Message-ID: <CAD53P8Bo8eeqZ0puMmfnyQJB_61MTU+eeXHRxED1989Nxa8A0w@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: Fix a typo in comment in ip_tunnels.h
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Patch looks okay.
> Perhaps in future trivial@kernel.org is suitable better for such fixes.

Thanks for the hint for trivial@kernel.org

>> I am new around and decided to start with something simple to test the process.
>> The fix applies both to net and net-next.
>
> Good. May be you are also interesting to run / contribute to the
> codespell tool [1].

No, I am more interested in playing with code rather than running
spellchecker over source comments :)

I stumbled upon this one while converting some tunnel related patches
for 3.2.x to net-next and used the opportunity for test. Just now
writing a RFC email because I think that my changes require
discussion/approval prior to submitting patches. And not to leave you
curious what I am working on - https://github.com/bbonev/eoip

With best regards,
b.
