Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab3AYMAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:00:41 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:65261 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783Ab3AYMAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:00:39 -0500
Message-ID: <1359115232.6647.14.camel@x61.thuisdomein>
Subject: Re: [PATCH v3] lpc_ich: fix gpio base and control offsets
From: Paul Bolle <pebolle@tiscali.nl>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Aaron Sierra <asierra@xes-inc.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?ISO-8859-1?Q?Ag=F3cs_P=E1l?= <agocs.pal.86@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 25 Jan 2013 13:00:32 +0100
In-Reply-To: <CACRpkdb0V=yasmJv1ygL7cq6G3uGf6+QAZ7GR5a3bb1-XJgiiA@mail.gmail.com>
References: <b9fec05c-d383-4282-b2af-c95855ff6abb@zimbra>
	 <3ffa5032-0565-48f0-a4ae-473452f4c902@zimbra>
	 <CACRpkdZHndQsDZpn7BCFNXAO3k5vREYxDJkcYQ3_3sTbKAQLLA@mail.gmail.com>
	 <1359108275.6647.4.camel@x61.thuisdomein>
	 <CACRpkdb0V=yasmJv1ygL7cq6G3uGf6+QAZ7GR5a3bb1-XJgiiA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jan 2013 12:00:32.0788 (UTC) FILETIME=[93D5ED40:01CDFAF3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-25 at 12:06 +0100, Linus Walleij wrote:
> Basically I do git log and when I see this I think:
> 
> commit 0c418844dce21fa7000b51190f393c7d6a7ee12d
> Author: Paul Bolle <pebolle@tiscali.nl>
> Date:   Mon Nov 19 21:04:11 2012 +0100
> 
>     mfd: lpc_ich: One uninitialized cell is no error
> 
> "Hm, there is another guy who's actually using this hardware."

I see, thanks. (Note to self: I should work on my psychic abilities. If
all those quacks can use them it can't be too hard.)

> "If this patch breaks it he will probably be upset."

I backported this patch to 3.7.5 (which I'm still running now). That
basically meant applying e294bc91760e11d2f1ebbac1d0a979069edf7adb ("mfd:
lpc_ich: Fix resource request for [mem 0x00000000]") first and then
manually adding some harmless context changes (ie, __devinit and
__devexit stuff).

Would testing on 3.7.5 be helpful?


Paul Bolle

