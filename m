Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbaHHSXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 14:23:04 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:44795 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaHHSXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 14:23:02 -0400
MIME-Version: 1.0
In-Reply-To: <1407516479-1251-6-git-send-email-olof@lixom.net>
References: <1407516479-1251-1-git-send-email-olof@lixom.net>
	<1407516479-1251-6-git-send-email-olof@lixom.net>
Date: Fri, 8 Aug 2014 11:23:00 -0700
X-Google-Sender-Auth: m76jvc8kT_al9QG8zUfiATcglS0
Message-ID: <CA+55aFydoHBfWZhNTtLR9894SZ_jb1230pmyMYXq6Vwfd02nkA@mail.gmail.com>
Subject: Re: [GIT PULL 5/7] .17 ARM: SoC driver changes for 3.17
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Olof Johansson <olof@lixom.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ARM SoC <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2014 at 9:47 AM, Olof Johansson <olof@lixom.net> wrote:
>
> drivers/phy/Kconfig:
>         Add/add. Keep both sides, sort (ST -> QCOM -> XGENE)

You may want to review your alphabet.

                 Linus
