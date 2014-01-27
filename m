Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbaA0OV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:21:56 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:63386 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbaA0OVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:21:54 -0500
Message-ID: <52E66B7F.3010209@cogentembedded.com>
Date: Mon, 27 Jan 2014 18:21:51 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>
CC: linux-xtensa@linux-xtensa.org, netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/3] net: ethoc: document OF bindings
References: <1390795167-6677-1-git-send-email-jcmvbkbc@gmail.com>	<1390795167-6677-4-git-send-email-jcmvbkbc@gmail.com> <CAL_JsqLjn4FXrNGLGHs639TEqmQKPx_kk9JbAd-hn7mexzAjNg@mail.gmail.com>
In-Reply-To: <CAL_JsqLjn4FXrNGLGHs639TEqmQKPx_kk9JbAd-hn7mexzAjNg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 27-01-2014 18:10, Rob Herring wrote:

>> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
>> ---
>>   .../devicetree/bindings/net/opencores-ethoc.txt    | 25 ++++++++++++++++++++++
>>   1 file changed, 25 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/net/opencores-ethoc.txt

>> diff --git a/Documentation/devicetree/bindings/net/opencores-ethoc.txt b/Documentation/devicetree/bindings/net/opencores-ethoc.txt
>> new file mode 100644
>> index 0000000..f7c6c94
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/opencores-ethoc.txt
>> @@ -0,0 +1,25 @@
[...]

>> +- reg: Address and length of the register set for the device and of its
>> +  descriptor memory.
>> +- interrupts: Should contain ethoc interrupt.
>> +
>> +Optional properties:
>> +- local-mac-address: 6 bytes, mac address

> There's a patch in progress to move all the standard network
> properties to a common location, so you can remove this.

    Haven't you asked me to replace the descriptions of common Ethernet props 
with the references to the common bindings file? I'd prefer this prop to 
remain on its place in this case, just the description replaced. 
Unfortunately, my patch will now have to wait till 3.15 (I guess), the same as 
these ones.

WBR, Sergei

