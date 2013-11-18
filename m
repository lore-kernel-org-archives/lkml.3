Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab3KRDZz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 22:25:55 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9982 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab3KRDZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 22:25:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 17 Nov 2013 19:19:54 -0800
Message-ID: <528988B5.2000509@nvidia.com>
Date: Mon, 18 Nov 2013 11:25:41 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: <shawn.guo@linaro.org>
CC: Jean Delvare <khali@linux-fr.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "rob@landley.net" <rob@landley.net>,
        Stephen Warren <swarren@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6] of: add vendor prefix for GMT
References: <1384340349-8626-1-git-send-email-wni@nvidia.com>
	<52835C42.6070806@nvidia.com> <20131113131332.63068fb1@endymion.delvare>
In-Reply-To: <20131113131332.63068fb1@endymion.delvare>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To: Shawn Guo <shawn.guo@linaro.org>

On 11/13/2013 08:13 PM, Jean Delvare wrote:
> On Wed, 13 Nov 2013 19:02:26 +0800, Wei Ni wrote:
>> Previous versions are:
>> [v5]: http://patchwork.ozlabs.org/patch/281017/
>> [v4]: http://lkml.indiana.edu/hypermail/linux/kernel/1309.1/02812.html
>>
>> On 11/13/2013 06:59 PM, Wei Ni wrote:
>>> Adding Global Mixed-mode Technology Inc. to the list
>>> of devicetree vendor prefixes.
>>>
>>> Signed-off-by: Wei Ni <wni@nvidia.com>
>>> Acked-by: Stephen Warren <swarren@nvidia.com>
>>> ---
>>>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
>>> index 2956800..64471a8 100644
>>> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
>>> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
>>> @@ -28,6 +28,7 @@ est	ESTeem Wireless Modems
>>>  fsl	Freescale Semiconductor
>>>  GEFanuc	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
>>>  gef	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
>>> +gmt	Global Mixed-mode Technology, Inc.
>>>  hisilicon	Hisilicon Limited.
>>>  hp	Hewlett Packard
>>>  ibm	International Business Machines (IBM)
>>>
> 
> Reviewed-by: Jean Delvare <khali@linux-fr.org>
> 

