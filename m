Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab3KMB5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 20:57:39 -0500
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:32213
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755239Ab3KMB5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 20:57:30 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zzbb2dI98dI9371I936eI542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh1724k1155h)
Message-ID: <5282DBC2.5090609@Freescale.com>
Date: Tue, 12 Nov 2013 19:54:10 -0600
From: Emil Medve <Emilian.Medve@Freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] phylib: Add Clause 45 read/write functions
References: <1384167864-2457-1-git-send-email-shh.xie@gmail.com> <1384293487.1403.67.camel@snotra.buserror.net> <ED492CCEAF882048BC2237DE806547C91512489F@039-SN2MPN1-013.039d.mgd.msft.net>
In-Reply-To: <ED492CCEAF882048BC2237DE806547C91512489F@039-SN2MPN1-013.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Xiao-Hui,


On 11/12/2013 07:51 PM, Shaohui Xie wrote:
>> -----Original Message-----
>> From: Wood Scott-B07421
>> Sent: Wednesday, November 13, 2013 5:58 AM
>> To: shh.xie@gmail.com
>> Cc: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Kanetkar
>> Shruti-B44454; Xie Shaohui-B21989; Bucur Madalin-Cristian-B32716
>> Subject: Re: [PATCH 1/4] phylib: Add Clause 45 read/write functions
>>
>> On Mon, 2013-11-11 at 19:04 +0800, shh.xie@gmail.com wrote:
>>> From: Andy Fleming
>>>
>>> You need an extra parameter to read or write Clause 45 PHYs, so we
>>> need a different API with the extra parameter.
>>>
>>> Signed-off-by: Andy Fleming
>>> Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
>>
>> Why did you remove Andy's e-mail address?  Even though it's no longer valid, it
>> helps identify which specific person you're talking about.
>>
> [S.H] Andy's e-mail address is not valid and git-send-mail will fail, I have to remove it to make git work.

Just use Andy's GMail address: afleming@gmail.com


Cheers,

