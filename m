Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161243AbaKNPtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:49:35 -0500
Received: from down.free-electrons.com ([37.187.137.238]:36422 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161026AbaKNPtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:49:33 -0500
Date: Fri, 14 Nov 2014 16:34:55 +0100
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Peter Chen <peter.chen@freescale.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] usb: chipidea: add a core function to setup
 ci_hdrc_platform_data
Message-ID: <20141114153455.GC2991@kwain>
References: <1414669007-9850-1-git-send-email-antoine.tenart@free-electrons.com>
 <1414669007-9850-2-git-send-email-antoine.tenart@free-electrons.com>
 <20141114011651.GA28697@shlinux2>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141114011651.GA28697@shlinux2>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Fri, Nov 14, 2014 at 09:16:55AM +0800, Peter Chen wrote:
> 
> Ok, Antoine, I find this patch set may not have many benefits due to
> below reasons:
> - There is already function ci_get_platdata to do the similar things
> - If the PHY can't get from the DT, it will use devm_phy_get or
> devm_usb_get_phy to get, this code has already in core.
> 
> I am apologized that I wanted you to do a patch for moving get PHY
> operation to core, it doesn't have many benefits currently
> - For non-dt user, the phy get function has already in core like I said
> above.
> - For dt generic phy user, it uses of_phy_get, the second parameter
> con_id may be different for platforms.
> - For dt usb phy, it uses devm_usb_get_phy_by_phandle, the second
> parameters phandle may be different for platforms.

Ok.

> So, please rebase my next tree which your generic phy patch set has
> already in, and send your generic usb2 chipidea patch base on it.

I just rebased my usb2 ci generic driver series and sent it to you and
to the mailing lists. Since there is not reason from now to delay it, I
expect it to be merged soon. I wouldn't want to miss yet another release.

Thanks,

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
