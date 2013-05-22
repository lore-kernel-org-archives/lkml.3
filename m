Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3EVINx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:13:53 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:36124
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445Ab3EVINt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:13:49 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc89bhda00hdc73hzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzzz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
Message-ID: <519C7ED3.3030004@freescale.com>
Date: Wed, 22 May 2013 16:16:19 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <arnd@arndb.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/6] drivers: bus: add a new driver for WEIM
References: <1369039742-10893-1-git-send-email-b32955@freescale.com> <1369039742-10893-2-git-send-email-b32955@freescale.com> <20130521054323.GE3080@S2101-09.ap.freescale.net>
In-Reply-To: <20130521054323.GE3080@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年05月21日 13:43, Shawn Guo 写道:
> It seems we can find it out from "reg" property, so that we can save
> this property?
>
we may have several devices attaching to the weim, each device has its 
own CS index.
it's better to keep this property, make it more clear.

thanks
Huang Shijie

