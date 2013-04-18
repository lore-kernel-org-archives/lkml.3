Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967173Ab3DRKsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:48:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59614 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967094Ab3DRKsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:48:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 07/32] ARM: ux500: Supply address location names for the DMA40 DMA controller
Date: Thu, 18 Apr 2013 12:48:36 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org> <1366279934-30761-8-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1366279934-30761-8-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181248.36597.arnd@arndb.de>
X-Provags-ID: V02:K0:zhwA2wb12qhWPtlicReGLh0dfnvILAQftnOlpZBp5G2
 N9zpw/U7i23iZVzR7790vU/uD8XX62ofEWOfKzq/jHYJErvAXZ
 fU/OGp6KfD66w37LW7vElMoiKBhr2xa5kkpi4TnmzQ5eJqhfnY
 U18phQVVYLFgEq0HUTcRoOQBlq+MWz3ByUILwmS18eoHPfOAD6
 DIyHPAvZOfK5N1y7Gp23U23wRTcVm+2h+VTpV0CBfIg1VQ2oYN
 uMCEgGFPzi+NANBc762q06zGcw5bzmwwCKvUzVnRDsioktzCnS
 G9S9nIMr5cNVF96aZBFCClgd0v+QHi2hbzDeNXf+hs2qPkcJz/
 4AQBRjGBcuxQTD5s8J0c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Lee Jones wrote:
> The DMA40 controller uses two sets of base addresses. In order to have
> them automatically setup as resources by the Open Format framework we
> have to set names for them. The names have to be the same as the ones
> used to fetch them back out of the resource structure.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Typo: s/Open Format/Open Firmware/

To be more specific, just write of_platform framework. Note that we
still get resources without passing the names, they are just not
named in that case and have to be retrieved by index.

You should also document the strings in the binding document.

	ARnd
