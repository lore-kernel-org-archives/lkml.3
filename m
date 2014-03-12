Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaCLOfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:35:42 -0400
Received: from [65.55.88.13] ([65.55.88.13]:32200 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754560AbaCLOfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:35:38 -0400
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zzbb2dI98dI9371I103dK1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
X-WSS-ID: 0N2BV57-08-EMV-02
X-M-MSG: 
Message-ID: <5320706B.2050405@amd.com>
Date: Wed, 12 Mar 2014 09:34:19 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>
CC: <clemens@ladisch.de>, <rob@landley.net>, <lm-sensors@lm-sensors.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <andre@andrep.de>
Subject: Re: [PATCH] hwmon, k10temp: Add support for AMD F16 M30h processor
References: <1394573159-2317-1-git-send-email-Aravind.Gopalakrishnan@amd.com>	<531FCF3D.8020409@roeck-us.net> <20140312102511.77faa6ff@endymion.delvare>
In-Reply-To: <20140312102511.77faa6ff@endymion.delvare>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/2014 4:25 AM, Jean Delvare wrote:
> On Tue, 11 Mar 2014 20:06:37 -0700, Guenter Roeck wrote:
>>
>> Looks good. We'll have to see how we can apply this; probably after 3.15-rc1
>> comes out. I'll put it into my -staging branch for now and pull in the other
>> patch as well to make sure it compiles.
> I've updated the wiki accordingly, as well as sensors-detect.
>

Thanks!

-Aravind.

