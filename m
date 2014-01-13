Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaAMJVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:21:53 -0500
Received: from ducie-dc1.codethink.co.uk ([37.128.190.40]:37815 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaAMJVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:21:49 -0500
Message-ID: <52D3B029.4060509@codethink.co.uk>
Date: Mon, 13 Jan 2014 09:21:45 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@lists.codethink.co.uk,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] power: clock_ops.c: fixup clk prepare/unprepare count
References: <1389445540-21426-1-git-send-email-ben.dooks@codethink.co.uk> <2133074.4EFCIDJZXE@avalon> <52D38787.5030505@codethink.co.uk> <CAMuHMdXek5YhKt9p-1LPXRuifqv6sazwzTZ+k6Ps=1-Myepirw@mail.gmail.com>
In-Reply-To: <CAMuHMdXek5YhKt9p-1LPXRuifqv6sazwzTZ+k6Ps=1-Myepirw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/01/14 08:50, Geert Uytterhoeven wrote:
> On Mon, Jan 13, 2014 at 7:28 AM, Ben Dooks <ben.dooks@codethink.co.uk> wrote:
>>> I've never noticed this on Lager, probably because Lager multiplatform
>>> doesn't
>>> make use of clock_ops.c as drivers/sh/pm_runtime.c (which you addressed in
>>> another patch that I've also replied to). I'm thus not sure we need to
>>> apply
>>> this as a fix and backport it to stable branches.
>>
>>
>> Yes, it seems that a lot of the lager drivers assume that this support
>> is there, and the work seems to have been sponsored by Renesas.
>
> I can confirm that applying both this and "[PATCH] ARM: shmobile: compile
> drivers/sh for CONFIG_ARCH_SHMOBILE_MULTI" makes

Thanks. Wonder how long this has been broken for?


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
