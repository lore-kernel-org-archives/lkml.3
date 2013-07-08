Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab3GHMJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 08:09:12 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:58377 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab3GHMJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 08:09:10 -0400
MIME-Version: 1.0
In-Reply-To: <1372949142-8260-1-git-send-email-jonas.jensen@gmail.com>
References: <1372949142-8260-1-git-send-email-jonas.jensen@gmail.com>
Date: Mon, 8 Jul 2013 14:09:10 +0200
Message-ID: <CACmBeS3Ges44HxOGZns+G=jQhSmGjVmZBir2_ZBXT1i2nrNQwg@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] ARM: reinsert ARCH_MULTI_V4 Kconfig option
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, arm@kernel.org, arnd@arndb.de,
        olof@lixom.net, Jonas Jensen <jonas.jensen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd suggested removing one (or many) of the options:

CPU_ABRT_EV4T
CPU_CACHE_V4WT
CPU_COPY_V4WB
CPU_TLB_V4WBI

However boot is still broken after removing all including CPU_32v4T.

Selecting CPU_SA1100 instead, it boots normally and init works.

The idea is, If you can help figure out what exactly breaks boot, the
patch can be dropped.

>From these tests, I have created two branches ( arch/arm/mm have
replacements for calls to no longer compiled in ):

http://code.google.com/p/linux-next-20130703-moxart/source/detail?r=a88f33ad22d3f9a31fe126f1c95568e5b2e8f32d&name=multi_V4_test_arm920t
http://code.google.com/p/linux-next-20130703-moxart/source/detail?r=9f4c21f1123a122c51792cd374217ce6e426e74a&name=multi_V4_test_sa1100

Best regards,
Jonas
