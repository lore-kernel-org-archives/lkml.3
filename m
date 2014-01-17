Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaAQXkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 18:40:55 -0500
Received: from void.printf.net ([89.145.121.20]:50973 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbaAQXkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 18:40:51 -0500
From: Chris Ball <chris@printf.net>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: John Tobias <john.tobias.ph@gmail.com>, Philip Rakity <prakity@nvidia.com>,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng <b29396@freescale.com>
Subject: Re: [PATCH] mmc: sdhci: fix possible scheduling while atomic
References: <1389988630-9481-1-git-send-email-abrestic@chromium.org>
	<0D8B1718-0A9D-467A-AFC5-108A868DE3BB@nvidia.com>
	<CACUGKYOojQ9XHj6ixrByuaEgPSqZNxr2Ls6pS4r_6nGVdLz52g@mail.gmail.com>
	<CAL1qeaHr=VGJCH-ngMAskd8O8qa6u+0cuXodBNshdKBD10V27w@mail.gmail.com>
Date: Fri, 17 Jan 2014 23:40:47 +0000
In-Reply-To: <CAL1qeaHr=VGJCH-ngMAskd8O8qa6u+0cuXodBNshdKBD10V27w@mail.gmail.com>
	(Andrew Bresticker's message of "Fri, 17 Jan 2014 15:16:42 -0800")
Message-ID: <86ha926utc.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, adding Aisheng,

On Fri, Jan 17 2014, Andrew Bresticker wrote:
> On Fri, Jan 17, 2014 at 3:11 PM, John Tobias <john.tobias.ph@gmail.com> wrote:
>> There's an existing patch for that...
>> http://www.spinics.net/lists/arm-kernel/msg296596.html
>
> Ah, I see.  Looks like it has yet to be picked up...

The patches aren't quite identical -- Andrew's leaves the
disable_irq() call in and Aisheng's removes it.  Which should I take?

Thanks,

- Chris.
-- 
Chris Ball   <chris@printf.net>   <http://printf.net/>
