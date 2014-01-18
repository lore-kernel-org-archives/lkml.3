Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaARDVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 22:21:14 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:52499 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbaARDVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 22:21:11 -0500
MIME-Version: 1.0
In-Reply-To: <86ha926utc.fsf@void.printf.net>
References: <1389988630-9481-1-git-send-email-abrestic@chromium.org>
	<0D8B1718-0A9D-467A-AFC5-108A868DE3BB@nvidia.com>
	<CACUGKYOojQ9XHj6ixrByuaEgPSqZNxr2Ls6pS4r_6nGVdLz52g@mail.gmail.com>
	<CAL1qeaHr=VGJCH-ngMAskd8O8qa6u+0cuXodBNshdKBD10V27w@mail.gmail.com>
	<86ha926utc.fsf@void.printf.net>
Date: Fri, 17 Jan 2014 19:21:09 -0800
X-Google-Sender-Auth: 7x8dhC0rfeE0VEoRwc97iRRws3g
Message-ID: <CAL1qeaFzWw-5zM2dLmBLYt-90U3Yy3iuOhoi-aUWsqcbyOBUCg@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci: fix possible scheduling while atomic
From: Andrew Bresticker <abrestic@chromium.org>
To: Chris Ball <chris@printf.net>
Cc: John Tobias <john.tobias.ph@gmail.com>, Philip Rakity <prakity@nvidia.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng <b29396@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 3:40 PM, Chris Ball <chris@printf.net> wrote:
> Hi, adding Aisheng,
>
> On Fri, Jan 17 2014, Andrew Bresticker wrote:
>> On Fri, Jan 17, 2014 at 3:11 PM, John Tobias <john.tobias.ph@gmail.com> wrote:
>>> There's an existing patch for that...
>>> http://www.spinics.net/lists/arm-kernel/msg296596.html
>>
>> Ah, I see.  Looks like it has yet to be picked up...
>
> The patches aren't quite identical -- Andrew's leaves the
> disable_irq() call in and Aisheng's removes it.  Which should I take?

Since the disable_irq() is now redundant, I suppose Aisheng's is more correct.

Thanks,
Andrew

>
> Thanks,
>
> - Chris.
> --
> Chris Ball   <chris@printf.net>   <http://printf.net/>
