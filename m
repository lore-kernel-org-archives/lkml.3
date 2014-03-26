Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbaCZWVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 18:21:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51589 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbaCZWVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 18:21:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 1/2] ARM: tegra: enable fhandle in tegra_defconfig
Date: Wed, 26 Mar 2014 23:20:37 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Alexandre Courbot <acourbot@nvidia.com>, arm@kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
References: <1395800972-26483-1-git-send-email-acourbot@nvidia.com> <53333303.70709@wwwdotorg.org>
In-Reply-To: <53333303.70709@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403262320.37195.arnd@arndb.de>
X-Provags-ID: V02:K0:1F+eyu/xEBbZyGh5L2GGEmLCouuiLlubWJBbFMrDdN/
 jiFJFmXzzNPhLG8Ja6lVJAQPHNh2jEk+SrbA/WQeYNOhu95Gb5
 IuliI9dbR7m1NLJMR29hrCIDKkoLY/XTIVTttiQ+FQ2CmumdPI
 U9w3I0+hVtlkYquEech7/fEOmHK4jqXrQY/8IZU3c+KJw41oKf
 g82VY6V2vK8LPi8Sf30455Z5XQ0NBeeFmJdbRf2GPSjeT5Q7VG
 ybH1L/Vb/c+zHIlY8YOREsk0zNzbvwZ/RFXfMaY4M8ExxXSbBZ
 Cv2eO9vRzBzBbxSJauuBhBeXX+bFFg8dqOryf8n6RCqjUSAbMX
 +KnVRGl6G6ttQ3zwQtCyK6lFVbdiP7PJXspdjRn0j
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 March 2014, Stephen Warren wrote:
> On 03/25/2014 08:29 PM, Alexandre Courbot wrote:
> > CONFIG_FHANDLE is required by systemd >= 210 to spawn a serial TTY.
> 
> The series,
> Acked-by: Stephen Warren <swarren@nvidia.com>
> 
> Patch 1/2,
> Tested-by: Stephen Warren <swarren@nvidia.com>
> (although not with the new systemd version that requires the change, but
> rather for regressions in Ubuntu 12.04)
> 
> 

Applied both to next/boards, thanks!

	Arnd
