Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab3E1X1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 19:27:10 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:55328 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759248Ab3E1X1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 19:27:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130525102544.GP2663@yliu-dev.sh.intel.com>
References: <1369456201-24910-1-git-send-email-yuanhan.liu@linux.intel.com>
	<CAE9FiQVZyizrB4=FV56hjeb_-vX_YWJ=Ur54ptTEeFpaekv16Q@mail.gmail.com>
	<20130525102544.GP2663@yliu-dev.sh.intel.com>
Date: Tue, 28 May 2013 16:27:07 -0700
X-Google-Sender-Auth: efshqPgALoGhbf9lrX1CHJQQlxU
Message-ID: <CAE9FiQXr4S0P5P5JdegRyozSX4OCJ6+6MMybmAaMPCzfqe6yWg@mail.gmail.com>
Subject: Re: [PATCH] x86, mm: fix boot hang regression
From: Yinghai Lu <yinghai@kernel.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkp@linux.intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 3:25 AM, Yuanhan Liu
<yuanhan.liu@linux.intel.com> wrote:

> Firstly, your patch works and feel free to add:
>         Tested-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>

ok, will resend it in complete form.

>
> While, your patch fixes this issue on source side. I thought that
> before, too.  But I think it's better to fix it on root side.
> That's why I sent a patch to try to fix it at mapping stage; Meanwhile,
> I was trying to sent another patch to fix this issue on source
> side later. And you did that.
>
> On the other hand, since we support splitting PUD(and PMD), I guess we
> should make it do the right work just in case will meet such case later.

No, we should not split them.

Thanks

Yinghai
