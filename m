Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaBCThe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:37:34 -0500
Received: from [213.199.154.207] ([213.199.154.207]:34837 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751686AbaBCThc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:37:32 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(z579ehzbb2dI98dI9371I1443I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h17326ah8275bh1de097h186068hz2dh839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h2516h1155h)
X-WSS-ID: 0N0FQI0-07-6X0-02
X-M-MSG: 
Message-ID: <52EFEFE7.2070805@amd.com>
Date: Mon, 3 Feb 2014 13:37:11 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <dougthompson@xmission.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] AMD64_EDAC: Fix logic to determine channel for F15 M30h
 processors
References: <1390338216-3873-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <52EFE9B2.9020104@amd.com> <20140203193203.GE4281@pd.tnic>
In-Reply-To: <20140203193203.GE4281@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/3/2014 1:32 PM, Borislav Petkov wrote:
> On Mon, Feb 03, 2014 at 01:10:42PM -0600, Aravind Gopalakrishnan wrote:
>> On 1/21/2014 3:03 PM, Aravind Gopalakrishnan wrote:
>>> The current logic that returns (sys_addr >> 8) & 0x7 when
>>> num_dcts_intlv = 4 is incorrect. We should really be doing-
>>> If intlv_addr = 0x4, then interleave on bits [9:8] and if
>>> intlv_addr = 0x5, interleave on bits [10:9].
>>>
>>> Refer F15 M30h BKDG D18F2x110[7:6] (DRAM Controller Select Low)
>>> (Link:http://support.amd.com/TechDocs/49125_15h_Models_30h-3Fh_BKDG.pdf)
>>>
>>> Tested on F15 M30h with mce_inj module and patch did not cause
>>> any regressions.
>>>
>>> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
>>> ---
>>>
>> Ping..
> I haven't forgotten you - it's just that I'm not taking any patches
> during the merge window.
yes, I realised :)
Just noticed rc1 on kernel.org; hence the ping..

Thanks in advance
-Aravind.

