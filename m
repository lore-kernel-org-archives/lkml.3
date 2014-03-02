Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaCBPtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 10:49:36 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:61089 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaCBPtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 10:49:35 -0500
MIME-Version: 1.0
In-Reply-To: <1393774826.13719.31.camel@joe-AO722>
References: <CAAOfnZp-KAFo8Q4bBW7oxe8BgUn+bSDAWuHbK6E+SF0X0Ex=Wg@mail.gmail.com>
	<53134C4D.2090406@linux.com>
	<1393774826.13719.31.camel@joe-AO722>
Date: Sun, 2 Mar 2014 16:49:33 +0100
X-Google-Sender-Auth: B-vzR8dHP0Mx4_HCRk07GB2aK9A
Message-ID: <CAAsK9AEWRD+n=bjAsJ-oRJsc+UQJ_LC+F9Psc+cCcK2rLzYsPw@mail.gmail.com>
Subject: Re: [PATCH 1/1] scripts/checkpatch.pl: to give more detailed warning
 message in case printk is used in any patch
From: Levente Kurusa <levex@linux.com>
To: Joe Perches <joe@perches.com>
Cc: Yogesh Chaudhari <mr.yogesh@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Robo Bot <apw@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-03-02 16:40 GMT+01:00 Joe Perches <joe@perches.com>:
> On Sun, 2014-03-02 at 16:20 +0100, Levente Kurusa wrote:
>> IMHO, this message is too big. The one we already have is nice and clean.
>> I would simply do: s/netdev/[subsystem]/ or something among the lines.
>
> maybe:
>
> "Prefer [subsystem eg: netdev]_$level2 then dev_$level2 then pr_$level to printk(KERN_$orig ...\n"

Excellent, that looks the best and combines the best of two worlds.

>
> or reference the stackoverflow link
>

And what if that disappears? Might as well write this to
Documentation/CodingStyle
as I have previously mentioned. Yogesh, you want to do this or should I?

--
Regards,
Levente Kurusa
