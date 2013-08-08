Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966625Ab3HHVCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:02:42 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:48072 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966586Ab3HHVCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:02:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130723075309.GE26801@laptop>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
	<1374490361-25769-6-git-send-email-lee.jones@linaro.org>
	<51EDAC90.6010108@broadcom.com>
	<20130723075309.GE26801@laptop>
Date: Thu, 8 Aug 2013 14:02:39 -0700
Message-ID: <CAGFynZ-+UoML32ecX4nSGAaFJXqQpdq+D8j7GqJSKhxsE7w=9A@mail.gmail.com>
Subject: Re: [PATCH 06/22] ARM: dts: bcm281xx: Remove '0x's from BCM11351 DTS file
From: Christian Daudt <csd_b@daudt.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Christian Daudt <csd@broadcom.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,
 I had to change some of the lines in the dts files you modified, so
I've added your mods. This patch:
https://lkml.org/lkml/2013/8/8/477

includes your changes to bcm11351.dtsi and bcm11351-brt.dts. Not sure
where your patch is at this point, but I just wanted to point that
out.

 Thanks,
   csd
