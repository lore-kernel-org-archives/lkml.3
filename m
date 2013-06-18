Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab3FRJMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:12:45 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:44618 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab3FRJMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:12:42 -0400
MIME-Version: 1.0
In-Reply-To: <1371467283-6981-1-git-send-email-jonas.jensen@gmail.com>
References: <1371467283-6981-1-git-send-email-jonas.jensen@gmail.com>
Date: Tue, 18 Jun 2013 11:12:41 +0200
Message-ID: <CACmBeS2Z=jYavSJqCqk5NnXhy-fq1CfNAZLp7Q3edGqtr=HNqg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] ARM: mach-moxart: add MOXA ART SoC files
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, arm@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I may have submitted this one too early. There are now a few things I
want to address:

* rename moxart_uc7112lx_defconfig moxart_defconfig
* remove MACH_UC7112LX "default y" from arch/arm/mach-moxart/Kconfig

Also, the omitted arch/arm/mach-moxart/idle.c hinges on a patch now
submitted to Russell's patch tracker:

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7760/1

Best regards,
Jonas
