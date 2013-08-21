Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab3HUEL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 00:11:56 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:1482
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773Ab3HUELz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 00:11:55 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h1155h)
Message-ID: <52143E23.9080203@freescale.com>
Date: Wed, 21 Aug 2013 12:12:19 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Philipp Zabel <p.zabel@pengutronix.de>, <kernel@pengutronix.de>,
        <gregkh@linuxfoundation.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH 0/3] refactor some ldb related clocks
References: <1376987932-5540-1-git-send-email-Ying.Liu@freescale.com> <1376991823.4000.22.camel@pizza.hi.pengutronix.de> <52134030.4030502@freescale.com> <20130821015939.GD30533@S2101-09.ap.freescale.net>
In-Reply-To: <20130821015939.GD30533@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 09:59 AM, Shawn Guo wrote:
> Hi Ying,
> 
> On Tue, Aug 20, 2013 at 06:08:48PM +0800, Liu Ying wrote:
>>> While I admit to having introduced the combination of 1/3.5 fixed
>>> divider and configurable 1/1,1/2 divder clocks to describe this
>>> fractional divider for the reasons you state, I think the correct
>>> solution would be to improve the table divider to support fractional
>>> values and get rid of the virtual ldb_di<n>_div_3_5 clocks, not
>>> introduce more virtual clocks.
>>
>> Yes, it's good to support fractional values for the table divider(not sure if there is any plan for this).
>> I see there is something similar in 'include/linux/sh_clk.h'.
> 
> Yeah, I agree with Philipp on improving table divider to support
> fractional values.  Would you like to work on that?
> 
> Shawn
> 

I don't have a plan to work on that now.

Liu Ying

