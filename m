Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933818Ab3CVPpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:45:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58941 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933457Ab3CVPpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:45:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/5] ARM: ux500: Add machine support for ccu8540
Date: Fri, 22 Mar 2013 15:45:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1363966065-2478-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1363966065-2478-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303221545.45630.arnd@arndb.de>
X-Provags-ID: V02:K0:NlQGFj5JN2Sch39cnqVbAW1yVpReTvBn7uMsKSEBldi
 mV0P5NKdzgzm/fQtHkxKNrzqvpkqQVFfvj071jnt70y7ImATo3
 HyIRR/u8mroRuxPn5MVruLXtkafhhKHhY+mtqrcN8cndGGBoa2
 CuIfnwdYDQoM0CLdL4GQGG8qLZoPRTk0DJZgIyj/eVduUCniqO
 5W3AtudTt99kFk6E1YyeSdl8YWFIUXngNBXpS835yZCOROO4VJ
 uMMF9dKhVHPRXSFqKZpqQLtimZEsH/yDRudRVM1UBjMyd63K/a
 Hb2r53v4J82eAMaXjD0Irf3KfSfCh5wxtxvXJ28u0ptJOMXMGP
 vgOpRIuZXgZZnGjqBZjs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 March 2013, Lee Jones wrote:
> Inform the kernel of a new machine type, so when detected it
> knows which initialisation route to travel though.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/mach-ux500/board-mop500.c |    9 +++++++++
>  arch/arm/tools/mach-types          |    1 +
>  2 files changed, 10 insertions(+)
> 

I'm not too happy to see another ATAGS based machine descriptor
in ux500. What is still missing for the DT boot?

	Arnd
