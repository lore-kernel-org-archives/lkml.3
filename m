Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbaFQGHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 02:07:04 -0400
Received: from mail-ph.de-nserver.de ([85.158.179.214]:47710 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaFQGHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 02:07:01 -0400
X-Fcrdns: No
Message-ID: <539FDB02.2020700@profihost.ag>
Date: Tue, 17 Jun 2014 08:06:58 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Cong Wang <cwang@twopensource.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Miller <davem@davemloft.net>,
        "bridge@lists.linux-foundation.org" 
	<bridge@lists.linux-foundation.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: netconsole breaks netpoll on bridge
References: <539EE86E.6030806@profihost.ag> <CAHA+R7OrT+x_jvDeqKgFc=ndebhB6qwecJBcT5y0ZAA+hBCJ3Q@mail.gmail.com> <6B8712E6-8012-42C3-9D98-0EBD943F2894@profihost.ag> <CAHA+R7NUKXJhaX45+OQx3ufxrWjkjnhO84cNznbijOZWru7u6w@mail.gmail.com> <CE582178-E749-473F-9D88-E6D7789A3B73@profihost.ag> <CAHA+R7Ncr_96hcTCgnxWnjXpKvW09DWMZ7J_W4n3GK0VtEo9VA@mail.gmail.com> <835D3F57-EB3A-4D30-B19C-7CC987D06C55@profihost.ag> <20140616213019.GA31594@electric-eye.fr.zoreil.com>
In-Reply-To: <20140616213019.GA31594@electric-eye.fr.zoreil.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.06.2014 23:30, schrieb Francois Romieu:
> Stefan Priebe - Profihost AG <s.priebe@profihost.ag> :
> [...]
>> That sounds great! Is there anything I can do or some code I can port to veth?
> 
> You may add an empty handler for .ndo_poll_controller in drivers/net/veth.c
> and give it a try on current kernel.
> 
> It should not be too bad.
> 
Why is an empty poll controller enough to fix it? This sounds a bit
crazy to me.


Greets,
Stefan
