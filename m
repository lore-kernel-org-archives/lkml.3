Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab3FDP4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 11:56:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49325 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3FDPz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:55:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH 1/2] ARM: ux500: Silence compiler warnings due to missing ux500_read_asicid() __init
Date: Tue, 04 Jun 2013 17:55:31 +0200
Message-ID: <2771350.uHLSSD79no@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1370360208-6500-1-git-send-email-lee.jones@linaro.org>
References: <1370360208-6500-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Xq3h9o3n2ygWGlQS2Za2/Jrmz6eigdBnQNfACXDiE7U
 wzfj6JgowYcPiaXnd8DJ0hon/xuK5YLxhnQ+XbptVndy1G2L72
 0/87sKz/1zNVs2MksW9QpgpdCdLihhJ1jHOKWDPcU3KlAJ4Bwq
 O98kaqxNoFXaw3q5CkScFJcKdEGyDml03EkAb6SdhgGNqZ6u1Q
 nhVGpVP8F1iME0uxRFUL57obkwAkeHkYwP8i3eQM+9mwBfX6xl
 Yd9CoSp0J4NeWJ0qKlMyhkS6LOM/KEqjTf11gxTH9s1XVt4nN2
 xBpizunmso7z6p/OSaarcv3rs2ndF9EoLjGc4AqMQZyMxEspVj
 A9kKmAP3B72PrefsAiZg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013 16:36:47 Lee Jones wrote:
> WARNING: vmlinux.o(.text.unlikely+0x1e8): Section mismatch in reference from\
>  the function ux500_read_asicid() to the function .init.text:iotable_init()
> The function ux500_read_asicid() references
> the function __init iotable_init().
> This is often because ux500_read_asicid lacks a __init
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

This is also part of my other patch to ux500_read_asicid that
Linus just applied, but we could take yours for 3.10 if he thinks
it's important.

	Arnd
