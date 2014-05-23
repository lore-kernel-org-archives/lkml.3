Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaEWXCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 19:02:03 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:63293 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaEWXCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 19:02:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH RESEND v2 0/3] bus: add Broadcom GISB bus arbiter timeout/error handler
Date: Sat, 24 May 2014 01:00:32 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Huang Shijie <b32955@freescale.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
References: <1400529962-9612-1-git-send-email-f.fainelli@gmail.com>
In-Reply-To: <1400529962-9612-1-git-send-email-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201405240100.32725.arnd@arndb.de>
X-Provags-ID: V02:K0:owXGrcvzATSCdUN90oYPtr1v0gpJXyYA/j5uf86prq/
 hJ0wXCuxin1ONxvkzSHYTU56ALyE0LvKcpEn1hQvYpwB/uRqYb
 v57CMxk8/tYG20cLMdp9rD8MXvf0bdu1DNeP/50ELf2u6O7npf
 pPLsalYGWPVg/RaU2YLC+U4Kd+d4K/9OGx2dngSuwXvsAkDG7Z
 8d0ZrXffT2waNM4M7Gn0tKYDt7r0LiOAZUeZGlPwV/n3v6W8dk
 gWtepnO9ya1OmUD5Wga4YwVFykMwcOaZGaITlpc5PR8Z8kaLxk
 goC2JJwx+Fj2dpQC5yECHfBrcxe2pw91pQTCyWmzTzh749VpNj
 1r+S6V72QS0UconSLWu8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2014, Florian Fainelli wrote:
> Hi all,
> 
> This patch adds support for the Broadcom GISB bus arbiter timeout/error handler.
> GISB is a custom and proprietary bus used in the Broadcom Set Top Box devices
> exclusively. The bus arbiter offers the possibly to decode faulting masters as
> well as masters that are timing out on the bus.
> 
> V2 addresses some comments made by Arnd, and widens the audience by posting
> on linux-arm-kernel as well.
> 
> These patches should be merged via the 'arm-soc' tree. I am resending those
> such that every mailing-list has them in copy.
> 
> Thank you!

Applied to the next/drivers branch now. I've changed the Kconfig and Makefile
slightly to maintain alphabetical ordering, which helps avoid a merge conflict
with the vexpress drivers.

	Arnd
