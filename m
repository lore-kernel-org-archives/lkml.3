Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab3FJLmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:42:03 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:41049 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3FJLmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:42:01 -0400
From: Rojhalat Ibrahim <imr@rtschenk.de>
To: Michael Guntsche <michael.guntsche@it-loops.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [BUG] PCI related panic on powerpc based board with 3.10-rcX
Date: Mon, 10 Jun 2013 13:41:52 +0200
Message-ID: <7927838.NMrLdRWptT@pcimr>
User-Agent: KMail/4.10.3 (Linux/3.4.26; KDE/4.10.3; x86_64; ; )
In-Reply-To: <CALG0vJu9-640D=Q-2RoSOnWtR=sERwj0fSCibK+ijprcf-T6Ag@mail.gmail.com>
References: <CALG0vJu9-640D=Q-2RoSOnWtR=sERwj0fSCibK+ijprcf-T6Ag@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

could you please try this patch:
https://lists.ozlabs.org/pipermail/linuxppc-dev/2013-May/106624.html
http://patchwork.ozlabs.org/patch/244515/

   Rojhalat


On Saturday 08 June 2013 21:39:37 Michael Guntsche wrote:
> After bisecting I found the responsible commit.
> 
> 50d8f87d2b3: powerpc/fsl-pci Make PCIe hotplug work with Freescale
> PCIe controllers
> 
> Reverting this commit allowed my board to boot again.
> 
> @Rojhalat: Please have a look at
> http://marc.info/?l=linux-kernel&m=137071294204858&w=2
> for my initial bugreport.
> 
> What I do not understand at all is why this is affecting my platform.
> AFAIK there is no PCIe hardware on it AND I completely disabled PCIe
> support in config.
> 
> Kind regards,
> Mike
