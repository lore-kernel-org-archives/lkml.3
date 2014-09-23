Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbaIWMl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:41:56 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:62448 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbaIWMly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:41:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com
Subject: Re: [PATCH v4 0/9] ARM: Berlin: Ethernet support
Date: Tue, 23 Sep 2014 14:41:47 +0200
Message-ID: <3200502.7xjfrZcKCM@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411474536-22626-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1411474536-22626-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Ebqsjc+z/MPsLrUQsn2/0ObKwhs+H+0NHJfVamkTmVl
 xePKUe6txPy6HtVGPwH4UAoLvIjs2igNM888PHHVNCHx9NlNZ7
 yDv6o0DvmpGbjaHunCDqBky6Zte1mWIG9GRJ4D/QUYSObdDP7P
 HT3E1GdeIec1DfXdAjW6iSACRHyfZTToW+MQtCVtzIza5JcyhG
 K4SosJcYncC2P0sBrPBo+Cp1SaCwppj6DZyYqJXE/6xU5xMv4F
 9zlDwrhvChFSRGqNnAYGOF1OvRF2TAVKhFGU7nsUaxdLa9rHGf
 B0ElvzrebVvXUjY1X6qTTHWoizNLnCqnM0nTDyVfmYwrv5Vdtm
 9DqExI8XUEVLA1K8xhZY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 14:15:27 Antoine Tenart wrote:
> 
> This series introduce support for the Ethernet controller on Berlin SoCs,
> using the existing pxa168 Ethernet driver. In order to do this, DT
> support is added to the driver alongside some other modifications and
> fixes.
> 

Looks great overall, I've commented on two issues I've found, but only
the phy-addr one really needs to be addressed. Once that is out of the
way, please add

Acked-by: Arnd Bergmann <arnd@arndb.de>
