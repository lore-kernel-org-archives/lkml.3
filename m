Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaCFUnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:43:47 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:37307 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaCFUnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:43:46 -0500
MIME-Version: 1.0
In-Reply-To: <5316BDB7.5060004@free-electrons.com>
References: <53063F09.9000102@free-electrons.com>
	<CAAsK9AGpuxCvQ_m+dJh_T72dHGaU3TU6AgSyWdf5YtzzJx==Vw@mail.gmail.com>
	<5316BDB7.5060004@free-electrons.com>
Date: Thu, 6 Mar 2014 21:43:46 +0100
X-Google-Sender-Auth: SxVpoUTCrSuXRMzr1ByJTUdcNP4
Message-ID: <CAMuHMdWbgi0gLX9qe6cZVdYtiexLCtrAi=Bim-R02Wc6mLE84Q@mail.gmail.com>
Subject: Re: How to get rid of IRQF_DISABLED for good?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Levente Kurusa <levex@linux.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Wed, Mar 5, 2014 at 7:01 AM, Michael Opdenacker
<michael.opdenacker@free-electrons.com> wrote:
>> Maybe once more, if they don't reply, send it to Andrew Morton as well
>> and CC a few people who know your work is good so that they can ACK it.
> I sent my patches once more, and will see which ones remain. Then I will
> send the changes to Andrew Morton as you suggested.

Just make sure to CC this round to Andrew Morton. There's no reason to
keep him out of the loop for one more cycle.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
