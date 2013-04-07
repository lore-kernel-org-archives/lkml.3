Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934392Ab3DGVXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 17:23:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64637 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762040Ab3DGVXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 17:23:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Tang <dt.tangr@gmail.com>
Subject: Re: [RFC PATCH arm: initial TI-Nspire support]
Date: Sun, 7 Apr 2013 23:23:41 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        fabian@ritter-vogt.de, Lionel Debroux <lionel_debroux@yahoo.fr>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
References: <6FE4B33E-A503-4A75-AEED-831CB2C06D83@gmail.com> <4B3FD561-84FC-40CD-B747-13851692D673@gmail.com> <521DFDFC-7E9E-47EA-ACDA-C91BBDC8454E@gmail.com>
In-Reply-To: <521DFDFC-7E9E-47EA-ACDA-C91BBDC8454E@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304072323.42173.arnd@arndb.de>
X-Provags-ID: V02:K0:mDe5NgvHgQYPVSfsIQUvrDTcgqhmXArSDIj7Bbk6Eiv
 I730x6VVdqwPwsuuxjRk6DFshgkKoBud6BNwNCoC2DYy1Zj2jT
 BR7afcELD6Z78PjB1MtdgKmizAJX59E1dtkXea+fbcPeClqp9j
 cFZvBs0hia7c3QDGZ2AefEPd/g2sdsS4jDCmC2p5KJbvClXq9y
 Rs3RSi4u8Dxu+103WVcrsXtSZ/WcBRwL009ODxLv4K4jGuWoEO
 ASykvH/DYQGnvXV2U3GLYrMRUdFqDjNojzxjB8xIBUTyrz4eaY
 AL/BWmitVUbhkE3YBrqiuPkSb3Vv2gvXV1xMb3F9YU0R5G8KV9
 2gvHx1KW9qImyAZlbGew=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 April 2013, Daniel Tang wrote:
> Here's an updated patch that enables support for the LCD.
> 
> I looked into drivers/video/of_display_timing.c but it doesn't have the fields to describe the PL11x specific options needed in struct clcd_panel. At the moment, it is implemented by hardcoding the values in the kernel and using the device tree to select the correct configuration.
> 
> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>

I think you should for now keep the clcd stuff in a separate file,
since it will be replaced with DT logic eventually. For now, the
auxdata method is ok, but Linus Walleij might already have thought
about how pl111 should get all its data from the device tree.

	Arnd
