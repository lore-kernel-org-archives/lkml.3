Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbbAZLFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:05:36 -0500
Received: from mail.linn.co.uk ([195.59.102.251]:55741 "EHLO mail.linn.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbbAZLFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:05:34 -0500
Message-ID: <54C61F7B.1000407@linn.co.uk>
Date: Mon, 26 Jan 2015 11:05:31 +0000
From: Stathis Voukelatos <stathis.voukelatos@linn.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Stathis Voukelatos <stathisv70@gmail.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH] net: Linn Ethernet Packet Sniffer driver
References: <1422007621-13567-1-git-send-email-stathis.voukelatos@linn.co.uk> <1817503.588aons8oi@radagast>
In-Reply-To: <1817503.588aons8oi@radagast>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.2.10.219]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 23/01/15 18:12, James Hogan wrote:
>> diff --git a/drivers/net/pkt-sniffer/Kconfig 
>> b/drivers/net/pkt-sniffer/Kconfig
>> new file mode 100644
>> index 0000000..26b4f98
>> --- /dev/null
>> +++ b/drivers/net/pkt-sniffer/Kconfig
>> @@ -0,0 +1,23 @@
>> +menuconfig PKT_SNIFFER
>> +    tristate "Linn packet sniffer support"
> Should the kconfig symbol have linn in the name, or should the prompt
> not have lin in the name?

No it should not actually, as this option enables the core (framework) 
driver.
Anybody could add a backend using the framework. Will change the text.

>> +
>> +config PKT_SNIFFER_ETHER
>> +    tristate "Ethernet packet sniffer"
>> +    depends on MIPS
> worth adding || COMPILE_TEST to get compile coverage on x86 allmodconfig
> builds, or does it have hard dependencies on the MIPS arch?
>

No hard dependencies on MIPS arch. Will change as you suggest.
Will implement your other recommendations too in the next version
of the patchset.

Thank you,
Stathis

