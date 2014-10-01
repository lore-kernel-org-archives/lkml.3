Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbaJAOeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:34:07 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:52243 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaJAOeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:34:05 -0400
X-Auth-Info: ywQu78SA5n30TVGl9tJhUrTR2IeIfAOPtzSE1expq/o=
From: Marek Vasut <marex@denx.de>
To: "Bean Huo =?utf-8?q?=E9=9C=8D=E6=96=8C=E6=96=8C?= (beanhuo)" 
	<beanhuo@micron.com>
Subject: Re: [PATCH 1/1 v3] driver:mtd:spi-nor: Add Micron quad I/O support
Date: Wed, 1 Oct 2014 16:32:02 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com> <201409301538.40466.marex@denx.de> <A765B125120D1346A63912DDE6D8B6315E3D3F@NTXXIAMBX02.xacn.micron.com>
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315E3D3F@NTXXIAMBX02.xacn.micron.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201410011632.02321.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 01, 2014 at 04:24:41 PM, Bean Huo 霍斌斌 (beanhuo) wrote:
> >> For Micron spi norflash,enables or disables quad I/O protocol ,which
> >> controled by EVCR(Enhanced Volatile Configuration Register) Quad I/O
> >> protocol bit 7.When EVCR bit 7 is reset to 0, the spi norflash will
> >> operate in quad I/O following the next WRITE ENHANCED VOLATILE
> >> CONFIGURATION command.
> >
> >You only do one WRITE ENHANCED VOLATILE CONFIGURATION command in the
> >patch, so this text doesn't add up.
> >
> >Try something like this:
> >-->8--
> >This patch adds code which enables Quad I/O mode on Micron SPI NOR
> >flashes.
> >
> >For Micron SPI NOR flash, enabling or disabling quad I/O protocol is
> >controled by EVCR (Enhanced Volatile Configuration Register), Quad I/O
> >protocol bit 7. When EVCR bit 7 is reset to 0, the SPI NOR flash will
> >operate in quad I/O mode. --8<--
> >
> >What do you think ?
> 
> Perfect,I will modify my commit message and sumbit it again.thanks.

Thank you. I didn't mean to grind you unnecessarily or be outright bitch, sorry 
if it did sound like so.

Best regards,
Marek Vasut
