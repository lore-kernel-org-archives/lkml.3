Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbaKTMhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:37:07 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:61607 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaKTMhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:37:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: cleanup for 3.19 #2
Date: Thu, 20 Nov 2014 13:36:52 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
References: <1415900716-20882-1-git-send-email-nicolas.ferre@atmel.com> <1415900892-20970-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1415900892-20970-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201411201336.53046.arnd@arndb.de>
X-Provags-ID: V02:K0:NA+wkIAV7RLXiO+3qZ6b6TM3i109GBW12xZWrjKWpxm
 /QmfIhf8gAY/Pzx9YpuFC8i0Zf4fpFMd32pa+hBIUlyB5SaqN2
 Q99HofcTE0zWJqmGuGggQgxY0IzvHsNp7lUouuR6ma1F3Dj+z5
 LtW2YUNcWYxB2ZIMDPCITAnGdJhyBDiiXuHEtVn1jJl0EZXui5
 MMZ8yNyZoxV+smvO8ZJ09Xu3rHVB2KxfxLblGRTpHdELWf+dRN
 pSw+5cslvl3M/ejec7s8gDmmefH6uI2Bty9Vth2LFynhQwlX1g
 UwXbwNbA4+F/5llOLFM20PuiyUZbTPZg29J7t742d71aT0JX8p
 ho8HIkkBKfPw6h6dEg0MKXFQf9lHU/5Woj3mJZaZC
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 November 2014, Nicolas Ferre wrote:
> Little pull-request with some fixes following the legacy board removal done
> earlier. I integrated the patch that Olof wrote in this branch before this series:
> please tell me if it works on your side or if I need to do things differently.
> The move of header files out of include/mach is useful for reset and memory
> drivers.
> More legacy code removal is in progress, but I didn't want to mix with this.
> So, bigger cleanup to come...
> 

Pulled into next/cleanup, thanks!

	Arnd
