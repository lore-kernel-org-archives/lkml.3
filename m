Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbbA2NKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:10:47 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:65409 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbbA2NKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:10:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH 1/2] dt: dma: Add DT binding document for jz4780-dma
Date: Thu, 29 Jan 2015 14:10:36 +0100
Message-ID: <2670922.EEM3IMjO9B@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1422533980-42761-2-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1422533980-42761-1-git-send-email-Zubair.Kakakhel@imgtec.com> <1422533980-42761-2-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:oQtSW+NVFM286WR+47GRI7rq2Ybf43wbhxviREUfIiY3kVGgXuN
 Z/PvBlfmRhmQhz1Xo0HIO6oX+uPL8R28JF8eHeB3z97eLJXtpu0E0LzVrpJO2+mi/OijzRt
 CuOvhbMUBN1OwdychHR5eBy1XK955rLyK/wdmJM+mEAhbNQp8GdY1oksODqoASFJu9b4o4m
 7sVugLi7A1w3PatoXAtsA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2015 12:19:38 Zubair Lutfullah Kakakhel wrote:
> 
> +1. Transmit request type: The DMA request type for transfers to the device on
> +   the allocated channel, as defined in the SoC documentation. If set to 0,
> +   transfers to the device will not be allowed on the channel.
> +
> +2. Receive request type: The DMA request type for transfers from the device on
> +   the allocated channel, as defined in the SoC documentation. If set to 0,
> +   transfers from the device will not be allowed on the channel.

It's fairly unusual to have separate fields for these two, most other
driver just use one. What would be a use-case for passing both?

	Arnd
