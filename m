Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaF3NU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:20:59 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:60398 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaF3NU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:20:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Paul Bolle <pebolle@tiscali.nl>,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v7 0/4] arm: Fix DEBUG_LL for multi-platform kernels (without PL01X)
Date: Mon, 30 Jun 2014 15:20:39 +0200
Message-ID: <4167835.TLMiA9Dyqd@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1404127855-30459-1-git-send-email-daniel.thompson@linaro.org>
References: <1401206421-29832-1-git-send-email-daniel.thompson@linaro.org> <1404127855-30459-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:lrMgegl9MEU8l/mdtxBKRqy81Uh1p6LRGzZ8+tI2qJr
 vgN7NHSIU8t/kCRLzWq3r6hwHwyJWXICjCbmuOskdq+5DQHxXw
 hoyGvAZ5/lb567uOdaLZFofoNj+B3Mf2Zp3XQIY86JhHU71EKq
 E1rpqnZ/HfDGD2NGTm4jY7AI1xj4Bgkykob9Kt0oHILCT2nXEJ
 8Ewa3075ZEf18wW/9jC/9D6JyMdIgTs1qfRRrB+V318/0fk+Lp
 LaXFHt+hY+dMdvwfCcN+j0tAudQ6LAtxAZ1n/Ks9AhWXD23hrC
 ngh1LbuP9BkM/SMX3c6KHJQoTu6dunIBEA87d8i5PP5ZKena6e
 Ox2uFhZToJ6XgAPxoESQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 June 2014 12:30:51 Daniel Thompson wrote:
> This patchset removes some single-platform compatibility tricks related
> to DEBUG_LL and, as a result, allows multi_v7_defconfig derived builds
> to enable DEBUG_LL. Currently the user selected kbuild setting is
> ignored and the PL01X's DEBUG_LL stub is silently selected instead. This
> is a pain if your hardware doesn't have this cell, not least because it
> takes a little time to figure out that kbuild built the wrong code.

Looks fine to me.

Acked-by: Arnd Bergmann <arnd@arndb.de>
