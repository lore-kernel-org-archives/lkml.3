Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610AbaLAV1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:27:08 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:57334 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbaLAV1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:27:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, devicetree@vger.kernel.org,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org,
        Andreas =?ISO-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Subject: Re: [PATCH] ARM: zynq: DT: Add USB to device tree
Date: Mon, 01 Dec 2014 22:26:55 +0100
Message-ID: <7088901.UGmPabvHQ0@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417459352-23401-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1417459352-23401-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:KOpLvN6vC+ABhHfy6BwmsEyCj4VZMkC5W8OlcIwXrEk
 zupftpRm7M1n1kN/+0GXoZkr6itfF94CNh1D04cBEAkX2CwoNc
 Wr2ZGGSAaNbWTcy4S0e6un77Sj3Zg2Y24DYdm5/kWG/Thk3jFo
 QjsIqKesLf37GULwiVflvtI+tR8QBuQ99CTFPTKpNpa2BXTPbf
 73X/nKcYgHSufd8i66ALiz/3Zy1hXgi4sK6uF8fQgB7Oq5bK3I
 iRI0I9lN2QBn/Q+FeJ1Qg0w0fbGc1W1aG76QUeKojl/qS3uGwS
 g9/j/aYneGV9HIqgnuM61IYxIDFl3RkEsCdIFQUiJ4JB42lQAH
 3wfRQaK/LvzD3xXL2MNQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 December 2014 10:42:32 Soren Brinkmann wrote:
> +       usb_phy0: usb-phy@0 {
> +               compatible = "usb-nop-xceiv";
> +               #phy-cells = <0>;
> +       };
>  };

As discussed in an unrelated thread today, please drop the "@0" in the
node name, since the device has no 'reg' property.

Otherwise looks good.

	Arnd
