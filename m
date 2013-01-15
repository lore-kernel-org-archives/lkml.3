Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab3AONh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:37:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62699 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab3AONh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:37:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [RFC PATCH 1/7] drivers: usb: phy: add a new driver for usb part of control module
Date: Tue, 15 Jan 2013 13:36:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: grant.likely@secretlab.ca, b-cousson@ti.com, rob.herring@calxeda.com,
        rob@landley.net, linux@arm.linux.org.uk, balbi@ti.com,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
References: <1358239378-10030-1-git-send-email-kishon@ti.com> <1358239378-10030-2-git-send-email-kishon@ti.com>
In-Reply-To: <1358239378-10030-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301151336.47546.arnd@arndb.de>
X-Provags-ID: V02:K0:RyQ25e6EYqi3FvALUVFxRIx4Sjia493PRL5sWBeBIJy
 5A5I5KTIRX6koPyR9jXj7m8JqrcOA1iHtl7JSSknq8Me2EvacP
 AWl1wu0T7MDbeTv5aSr0h9DGu6tCsJfYuUp3bQCpOfzbymV5oI
 P8ONueZUCM9rqwg7eCsQ5MREkrRPEq6lfu4dasuYuqz+3h/Mns
 LHMkLWpqlUkFSmWPhRpPi+agmMnBbG+915BEd7Di2Fr8Xb5gSn
 iIJDZ/gXYvqSonhEzWmlR4T3fK2IKIaN7ecidzxjmFbttmlHd2
 huz0Z5VoLBAhqW4vfz6A1id5uiF7j9K5aQEVsaHc8TLug5FPTh
 d2XFpcHl/ZUwiNstUpLo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2013, Kishon Vijay Abraham I wrote:
> +OMAP CONTROL USB
> +
> +Required properties:
> + - compatible: Should be "ti,omap-control-usb"
> + - reg : Address and length of the register set for the device. It contains
> +   the address of "control_dev_conf" and "otghs_control".
> + - reg-names: The names of the register addresses corresponding to the registers
> +   filled in "reg".
> + - ti,has_mailbox: This is used to specify if the platform uses mailbox in
> +   control module.

I wonder whether we need to have a phandle here to connect the control device
to the actual usb device. What happens if you have multiple instances of
each?

	Arnd
