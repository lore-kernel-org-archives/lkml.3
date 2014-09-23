Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbaIWOhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:37:32 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:52479 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953AbaIWOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:37:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com, sebastian.hesselbarth@gmail.com
Subject: Re: [PATCH v4 3/9] Documentation: bindings: net: add the Marvell PXA168 Ethernet controller
Date: Tue, 23 Sep 2014 16:37:17 +0200
Message-ID: <4014272.rJbSfrLcuB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140923142922.GE18924@kwain>
References: <1411474536-22626-1-git-send-email-antoine.tenart@free-electrons.com> <20140923140113.GC18924@kwain> <20140923142922.GE18924@kwain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:HN/YsiTuUoudUUuUDUTNwWoduZGIBbZikZ+OmBumwqg
 kJyJYUdTpKdcajaooT/ykJV9QeAKFSL5zNBtG5ib6hUJj6aaGz
 tSr9LPkVBmEgMOqW8owayo4wSUylty2OEnm9GJI9fPWlXmNbzV
 pcHjW+TBNWoGW/ghzljQPBLJVVMHMOAYBolAwxOQFJyYlIp0e/
 Imw+Z8913JG8aBL31a/7y9430yp3jd0cApWeFMcys+jK4fnBIR
 yDHyFZ3AOwBR3zQzsRTUiSTtLWNRufUjAJbxDEOHrZ1gIgloWd
 MWH3BObjcuUdw2692AWp1XmFJoCTYZZYwd8QOxPoOS+LinTXiI
 hLvr7G46XkQfz4SoI/GI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 16:29:22 Antoine Tenart wrote:
> 
> So I had a look on other Ethernet bindings. Would you agree with
> something like the following?
> 
>         eth0: ethernet@f7b90000 {
>                 ...
>                 #address-cells = <1>;
>                 #size-cells = <0>;
>                 phy-handle = <&ethphy0>;
> 
>                 ethphy0: ethernet-phy@0 {
>                         reg = <0>;
>                 };
>         };

Yes, that looks good.

	Arnd
