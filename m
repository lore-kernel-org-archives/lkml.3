Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbaJIHeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 03:34:06 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:55257 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaJIHds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:33:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Scott Branden <sbranden@broadcom.com>
Cc: linux-arm-kernel@lists.infradead.org, Christian Daudt <bcm@fixthebug.org>,
        Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, devicetree@vger.kernel.org,
        Ray Jui <rjui@broadcom.com>, linux-kernel@vger.kernel.org,
        Jonathan Richardson <jonathar@broadcom.com>,
        JD Zheng <jdzheng@broadcom.com>
Subject: Re: [PATCH 1/6] ARM: cygnus: Initial support for Broadcom Cygnus SoC
Date: Thu, 09 Oct 2014 09:32:33 +0200
Message-ID: <2721519.urlXjs6OJF@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5435B7D7.1030904@broadcom.com>
References: <1412746025-11998-2-git-send-email-sbranden@broadcom.com> <34012512.W8VifyXY4H@wuerfel> <5435B7D7.1030904@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:T3JyJncvPrCvChjoWq4tuZQcfVwKMg72Z08eh6W+oOi
 SDl+BY6C3775mJBgafwgqBRO639v3devb4nY8ilRb0OUaY6Mrx
 dRa8bc7hNsK/wJx4LUQNk1MGxDI8tRmrmCyjz15PY0N9sAc6En
 Dk1hEnfGqqHdGV+3otWUYeE0SVNuDdQv3v5uvUw/JJAjAatfV7
 S+06NWnNq08myZQG9ZX/2SgCdM5NnP7BICHIqm4bxh8NfwJgxR
 AdOrXTO4BeI2J/yY0e5jD+v3uezmOsCu3Vr0VUzqZfeMktjwGh
 4L6qZ85HG3gtN6uRC9PMhrndq2bnsl7M9wBRqKDQ9GxnYhRAlA
 gPpVj6T+BMVuiD6353ho=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2014 15:16:55 Scott Branden wrote:
> It looks like I will also be able to add Northstar under the 
> ARCH_BCM_IPROC.  This will be good momentum to cleaning up and 
> consolidate support going forward.
> I will change the Kconfig such that ARCH_BCM_5301X selects ARCH_BCM_IPROC.
> 
> 

Ok, sounds good.

	Arnd
