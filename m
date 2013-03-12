Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab3CLJot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 05:44:49 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:42320 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab3CLJos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 05:44:48 -0400
MIME-Version: 1.0
In-Reply-To: <1363074487-21248-1-git-send-email-silviupopescu1990@gmail.com>
References: <1363074487-21248-1-git-send-email-silviupopescu1990@gmail.com>
Date: Tue, 12 Mar 2013 10:44:47 +0100
X-Google-Sender-Auth: zYrszmkAeruCP0mKQ5aZGZUqEWg
Message-ID: <CAMuHMdWDiWoyhufMrtQzwuB93dX6ydRC+y8dS+_8Y4qGPHQcMg@mail.gmail.com>
Subject: Re: [PATCH] ethernet: amd: use PTR_RET instead of IS_ERR + PTR_ERR
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, joe@perches.com,
        dhowells@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 8:48 AM, Silviu-Mihai Popescu
<silviupopescu1990@gmail.com> wrote:
> This uses PTR_RET instead of IS_ERR and PTR_ERR in order to increase
> readability.
>
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>

Acked-by: <Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
