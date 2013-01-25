Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab3AYMn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:43:56 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:51982 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3AYMnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:43:53 -0500
MIME-Version: 1.0
In-Reply-To: <1359115232.6647.14.camel@x61.thuisdomein>
References: <b9fec05c-d383-4282-b2af-c95855ff6abb@zimbra>
	<3ffa5032-0565-48f0-a4ae-473452f4c902@zimbra>
	<CACRpkdZHndQsDZpn7BCFNXAO3k5vREYxDJkcYQ3_3sTbKAQLLA@mail.gmail.com>
	<1359108275.6647.4.camel@x61.thuisdomein>
	<CACRpkdb0V=yasmJv1ygL7cq6G3uGf6+QAZ7GR5a3bb1-XJgiiA@mail.gmail.com>
	<1359115232.6647.14.camel@x61.thuisdomein>
Date: Fri, 25 Jan 2013 13:43:53 +0100
Message-ID: <CACRpkdbUU=TOeaHNwAw-=iTxtkQDNuS4KeVBFX4yirZa+fQ2uw@mail.gmail.com>
Subject: Re: [PATCH v3] lpc_ich: fix gpio base and control offsets
From: Linus Walleij <linus.walleij@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Aaron Sierra <asierra@xes-inc.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?ISO-8859-1?B?QWfzY3MgUOFs?= <agocs.pal.86@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 1:00 PM, Paul Bolle <pebolle@tiscali.nl> wrote:

> I backported this patch to 3.7.5 (which I'm still running now). That
> basically meant applying e294bc91760e11d2f1ebbac1d0a979069edf7adb ("mfd:
> lpc_ich: Fix resource request for [mem 0x00000000]") first and then
> manually adding some harmless context changes (ie, __devinit and
> __devexit stuff).
>
> Would testing on 3.7.5 be helpful?

Sure it's as good an indicator of the quality of the patch as any.

If it works on that kernel, it makes probablility lower that it breaks
your machine later on atleast.

Thanks!
Linus Walleij
