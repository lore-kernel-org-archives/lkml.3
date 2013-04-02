Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952Ab3DBCTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 22:19:24 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:38717 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758625Ab3DBCTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 22:19:22 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r322JF2I014889, This message is released by code: ctlocs8528
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1364824539-4156-1-git-send-email-hayeswang@realtek.com> <1364824539-4156-2-git-send-email-hayeswang@realtek.com> <20130401222048.GA19335@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH net-next 2/7] r8169: Update PHY settings of RTL8111G
Date: Tue, 2 Apr 2013 10:19:17 +0800
Message-ID: <2CDCEE66B3D64940AB7259FBACFFDC6F@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac4vJy0GO/ZT1bF0QA2RYKVN018QYgAH3Kgg
In-Reply-To: <20130401222048.GA19335@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu [mailto:romieu@fr.zoreil.com] 
> Sent: Tuesday, April 02, 2013 6:21 AM
> To: Hayeswang
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next 2/7] r8169: Update PHY settings 
> of RTL8111G
> 
> Hayes Wang <hayeswang@realtek.com> :
> > - Replace the current settings with rtl_writephy and rtl_readphy.
> >   For the hardware, the settings are same with previous ones. This
> >   make the setting method like the previous chips.
> > - Add new PHY settings.
> 
> Would you mind spliting it in two ?

OK.

[...]
> > -	if (r8168_phy_ocp_read(tp, 0xa466) & 0x0100)
> > -		rtl_w1w0_phy_ocp(tp, 0xc41a, 0x0002, 0x0000);
> > -	else
> > -		rtl_w1w0_phy_ocp(tp, 0xbcc4, 0x0000, 0x0002);
>                                      ^^^^^^
> This one was not right, was it ?

No, it was not right. It seems a mistake for copying and pasting.

