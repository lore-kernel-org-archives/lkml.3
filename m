Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021AbaFOInE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 04:43:04 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:44077 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaFOIm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 04:42:59 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1406130829370.23090@tomh.mtv.corp.google.com>
References: <alpine.DEB.2.02.1406130829370.23090@tomh.mtv.corp.google.com>
Date: Sun, 15 Jun 2014 10:42:57 +0200
X-Google-Sender-Auth: ojSYNgk4P4TaIbYmS02SqCFmv6o
Message-ID: <CAMuHMdV+wjdEqKANwu4b=LX1t6X8dhfZKdyCkWB-9KXztPmNhg@mail.gmail.com>
Subject: Re: [-next] Regression: ssh log in slowdown
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tom Herbert <therbert@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux-Next <linux-next@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

On Fri, Jun 13, 2014 at 5:37 PM, Tom Herbert <therbert@google.com> wrote:
>> Thanks, I applied the series "[PATCH 0/4] Checksum fixes", and the fix
>> above, but it doesn't help.
>>
>> Note that I'm also using NFS root, which doesn't seem to be affected.
>> I can happily run "ls -R /" on the serial console during the 10 s delay
> in ssh.
>
> Can you try one more patch below with the series applied? Also, can you

This patch fixes the issue. Thanks!

> look at 'netstat -s' to see if UDP checksum errors are being reported.

Indeed, errors are reported under Udp/InCsumErrors.
With this new patch, no errors are reported.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
