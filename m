Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbaAMNco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 08:32:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55026 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaAMNcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 08:32:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Prabhakar Kushwaha <prabhakar@freescale.com>
Subject: Re: [PATCH] Driver/IFC: Move Freescale IFC driver to a common driver
Date: Mon, 13 Jan 2014 14:32:36 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        scottwood@freescale.com
References: <1389590671-20289-1-git-send-email-prabhakar@freescale.com>
In-Reply-To: <1389590671-20289-1-git-send-email-prabhakar@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201401131432.36880.arnd@arndb.de>
X-Provags-ID: V02:K0:MNYSxQQpuAjrWgvzFkR8QDowH+adsashIgfeNUf6Dpc
 VMJxmiyNBvDwytyQ2p8FOW46xFhDNIuTC/W4pHECA4AaeIglsG
 ZK7g0Lc5UECzvkftY+42CWv3sa+K5rTprOk3guT/iX7ENn/+k7
 Busu6GeTJ+ks03IMNCukM4XMX6SRoj5b++lILA/dIwP8zJA3xd
 9WwA46AlRWJS2bPcKaGhRgQWZBMS5cI+5dqfdFtR5piaIn8InE
 IhSTnL1MGOMQ0NDLJ9YpdogjolfjghCtsn9oRxvpTZ5HN8hIvf
 +9CeCAClwuLnovy8xkqwQhfdwlM7JvYkUkD38h1QRWBZQ1B+zD
 yC0fdeSHyl7KpxghxFaY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 January 2014, Prabhakar Kushwaha wrote:
> Freescale IFC controller has been used for mpc8xxx. It will be used
> for ARM-based SoC as well. This patch moves the driver to driver/misc
> and fix the header file includes.
> 
> Signed-off-by: Prabhakar Kushwaha <prabhakar@freescale.com>

No objections to the driver, but drivers/misc doesn't seem like the
right place. Why not drivers/mfd or drivers/memory?

You should also find a new place for the binding file, which is
currently in Documentation/devicetree/bindings/powerpc/fsl/ifc.txt.

	Arnd
