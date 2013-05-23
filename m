Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab3EWCPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 22:15:05 -0400
Received: from [216.32.181.181] ([216.32.181.181]:3546 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756474Ab3EWCPD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 22:15:03 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Ic89bhzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzzz2dh2a8h668h839h941hd25he5bhf0ah1269h1288h12a5h12a9h12bdh12e1h1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
Message-ID: <519D7C2C.9080506@freescale.com>
Date: Thu, 23 May 2013 10:17:16 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Shawn Guo <shawn.guo@linaro.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/6] drivers: bus: add a new driver for WEIM
References: <1369039742-10893-1-git-send-email-b32955@freescale.com> <20130521054323.GE3080@S2101-09.ap.freescale.net> <519C7ED3.3030004@freescale.com> <201305221459.34859.arnd@arndb.de>
In-Reply-To: <201305221459.34859.arnd@arndb.de>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年05月22日 20:59, Arnd Bergmann 写道:
> On Wednesday 22 May 2013, Huang Shijie wrote:
>> 于 2013年05月21日 13:43, Shawn Guo 写道:
>>> It seems we can find it out from "reg" property, so that we can save
>>> this property?
>>>
>> we may have several devices attaching to the weim, each device has its 
>> own CS index.
>> it's better to keep this property, make it more clear.
> I agree with Shawn, we should not have this property when it is the
> same as the upper half of the "reg" property.
okay. I will remove this property.

thanks
Huang Shijie


