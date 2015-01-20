Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbbATGYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 01:24:52 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:46106 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbATGYv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 01:24:51 -0500
MIME-Version: 1.0
In-Reply-To: <20150119190216.7ce58d74@neptune.home>
References: <CA+55aFxNk9OCXz7nvKXpRBc0Z85NLXPNkRm1yJf4-KAGB4pHRA@mail.gmail.com>
	<20150119190216.7ce58d74@neptune.home>
Date: Tue, 20 Jan 2015 18:24:50 +1200
X-Google-Sender-Auth: cWdBPbrNF9Et2QfJJIAVR2H3iRA
Message-ID: <CA+55aFw7aoShsqS_ro5DASbseXFLQs_sE=dwLp_tTNAvD9Y09w@mail.gmail.com>
Subject: Re: Linux 3.19-rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 6:02 AM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
>
> No idea yet which rc is the offender (nor exact patch), but on my not
> so recent UP laptop with a pccard slot I have 2 pccardd kernel threads
> converting my laptop into a heater.
>
> lspci for affected nodes:
> 02:06.0 CardBus bridge [0607]: O2 Micro, Inc. OZ711EC1 SmartCardBus Controller [1217:7113] (rev 20)
> 02:06.1 CardBus bridge [0607]: O2 Micro, Inc. OZ711EC1 SmartCardBus Controller [1217:7113] (rev 20)
>
> Very basics I have, before I attempt any bisection:

Hmm. I'm not seeing anything recent changing anything in this area, so
I suspect that unless somebody else steps up and says "Ahh, that
sounds like xyz", your bisection is the best option.

                   Linus
