Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab3BPXPd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 18:15:33 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:59082 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab3BPXPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 18:15:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Emilio =?iso-8859-1?q?L=F3pez?= <emilio@elopez.com.ar>
Subject: Re: [PATCH 01/11] ARM: disable virt_to_bus/virt_to_bus almost everywhere
Date: Sat, 16 Feb 2013 23:15:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de> <1360849767-1463135-2-git-send-email-arnd@arndb.de> <BLU0-SMTP3204E8218EA90D50AB340558A0D0@phx.gbl>
In-Reply-To: <BLU0-SMTP3204E8218EA90D50AB340558A0D0@phx.gbl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201302162315.18551.arnd@arndb.de>
X-Provags-ID: V02:K0:dHdBbLKDthRoKwRg+RqHI4/0ooMyWS/jkiaUhC107CI
 EUVPsrMadSnIncdpZcQ20Y0YogiAZksCGdOIZKH43Ik9BXJJp3
 BJDP08PkC/mgbT/btADtb5hbhOvOazLArbkJIRSTgNsn/3wkRU
 evU8Vkpcwu980twdpY1xO3yDmfimc0V4nZPawB8MdQrf2dbKnK
 xPNOjvt0k0eaqq+SPyHjig/eMUqG1s8hPvj3sGz1oYFLfl0kFV
 N0soVoFRcxbqlj/2AXI/TNOSmXPae92lLeWuaTYvvhUlKGrc8/
 IqF0WhAwgTyCZRGU+ntGiYqY+u/lZmUuGk/UK4rmgmohsvJUvi
 xLWRTvg/cOs6VrQOQFog=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 February 2013, Emilio López wrote:

> Small nitpick: Please have a look at the patch subject, I suppose you
> meant something like "virt_to_bus/bus_to_virt" instead of
> "virt_to_bus/virt_to_bus".

Yes, absolutely right, thanks for your attention. The patch is already
applied to a stable branch now, so I would prefer not to rebase it
though. If there is an important reason to change the applied patches,
I will fix this one as well.

	Arnd
