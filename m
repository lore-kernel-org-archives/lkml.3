Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3CEI3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:29:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:52832 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3CEI3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:29:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 1/3] misc: arm-charlcd: use module_platform_driver_probe()
Date: Tue, 5 Mar 2013 08:29:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
References: <004b01ce1945$79486af0$6bd940d0$%han@samsung.com>
In-Reply-To: <004b01ce1945$79486af0$6bd940d0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303050829.31804.arnd@arndb.de>
X-Provags-ID: V02:K0:XtMbYJjUDNggdmeXRLf5gnys89a2V6ew5wGu6cPBmks
 3LJNP3HnCxnpORGtyfdaLF5vf7avvfhf1gPhxmCDv7WBahXl9n
 IPoA4LMVS2A6xc4EvHhUduxVIMUGKERvdgCEKaYMB9bMeeWRud
 JfZvjBv2LKIaJuFyPawtdcrTGiYO/HKCc8s0tg40PCDgCmbYxF
 onkc7MnZVTSzW4Q0Aa36C+38BEZ9NaP9u65uqYytbMuWwr1agD
 84rMoq1q8IKwgwiemEGl+mTMRPW5jkc3LoYqLr6eICCAB4VIIb
 mOkrEww/QXSxkDIh90V0clCRgbxKLty1Sy+DuYTgci5A0CjdiM
 hw06FX6WCYhnP41X0wf8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 March 2013, Jingoo Han wrote:
> 
> This patch uses module_platform_driver_probe() macro which makes
> the code smaller and simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Arnd Bergmann <arnd@arndb.de> 

(all three patches)
