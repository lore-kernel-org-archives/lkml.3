Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431Ab3DYVNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 17:13:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51614 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759250Ab3DYVND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 17:13:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 18/21] USB: ehci-msm: USB_MSM_OTG needs USB_PHY
Date: Thu, 25 Apr 2013 23:12:59 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de> <1366910944-3033663-19-git-send-email-arnd@arndb.de> <20130425175950.GA14654@kroah.com>
In-Reply-To: <20130425175950.GA14654@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304252312.59822.arnd@arndb.de>
X-Provags-ID: V02:K0:VxZ4k/uhYUF9oGw46eIhdX5RB06Oaic1vRJKZFTErYC
 KnhBhbkzYuHGbM5zxiftFQc4Wca6z91YcpQdP19RydYpV5ar99
 BqdxnzKw4yo8ZlzkJljXruGo492emDNlwz+LudBo6l3vUfSjKm
 jgFEc4Pmgtsb4TwNXuC1hb01iGBtyoRc5SQ9gTGKvZqmqgGNtQ
 b21n953SlXduuqQsdUbu/84gJajCYC/Z7LKE0o03hjmJirL/ED
 cwM4D3afLD+K19tEMlhMYf5uakV5zTsFDumOX6SKJBomEaIW0l
 KlLJLpR5Is0S4sF2djpOnXR3ixUUWRrtWswqrtEBaIl1K4sy48
 XJGDxBi+kGNnPGnVqs9I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 April 2013, Greg Kroah-Hartman wrote:
> > diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> > index c558472..de94f26 100644
> > --- a/drivers/usb/host/Kconfig
> > +++ b/drivers/usb/host/Kconfig
> > @@ -188,6 +188,7 @@ config USB_EHCI_HCD_AT91
> >  config USB_EHCI_MSM
> >       tristate "Support for Qualcomm QSD/MSM on-chip EHCI USB controller"
> >       depends on ARCH_MSM
> > +     depends on USB_PHY
> >       select USB_EHCI_ROOT_HUB_TT
> >       select USB_MSM_OTG
> >       ---help---
> 
> But this does, and I'm guessing that it's the more important part, so
> I'll just edit it and only take this hunk, ok?

Ok, thanks! Sorry for bothering you with the hand editing. I'll apply
the defconfig change to arm-soc then.

	Arnd
