Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbaJHNuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:50:23 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:50752 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbaJHNuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:50:21 -0400
Message-ID: <5435410C.4040005@pivasoftware.com>
Date: Wed, 08 Oct 2014 14:50:04 +0100
From: Oussama Ghorbel <ghorbel@pivasoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Roger Quadros <rogerq@ti.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, Rabin Vincent <rabin@rab.in>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] phy: omap-usb2: Enable runtime PM of omap-usb2 phy
 properly
References: <20141006194418.GA399@debian> <1412679771-8293-1-git-send-email-ghorbel@pivasoftware.com> <5434F336.4040908@ti.com> <543517F9.9070109@pivasoftware.com> <54352340.3050900@ti.com> <20141008132615.GA5119@kroah.com>
In-Reply-To: <20141008132615.GA5119@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:bUc8lm6EuS7ly/2abQEiqC6bKAR94w7/xwULaygQHJ4
 0iDpa67+3/tV/DQ8+k6zaBVYg6S0Zap6ucetN/vuhCG7maZRak
 /t6RK7w+Fudqxgn6Uu7sOggahgd5lB7tGR0pqpQoqlMc1Ldsj3
 oWc24RQJhJlBow5SNGNCBxStxobGO2otx9S59D/xX3bH3RsFMO
 Ag7mkJhpjE75bIS/r1Zgi8cyv/lOyNaVPhjAzJQqw5CJnLBM2w
 5hYdKHI4j8w3OUVfmQDdkDK9oquAsY8HbovBLGTDjpjJL4erdu
 nmByGwzKKhjBK3Mj4TO7Gqqf6vOgClTyU5hCP0UdKPsXVRhnJe
 X0cdHsBD8u2BkFaTkP2ZgBXeqLqZbxaV7TtVupaY/
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing to send then.

Oussama
On 10/08/2014 02:26 PM, Greg KH wrote:
> On Wed, Oct 08, 2014 at 02:42:56PM +0300, Roger Quadros wrote:
>> Oussama,
>>
>> On 10/08/2014 01:54 PM, Oussama Ghorbel wrote:
>>> Hi Roger,
>>>
>>> Should I resend this v2 version of the patch to stable@vger.kernel.org which is suitable for v3.17 and which will require a very tiny adaptation?
>>> Or I should resend the first version of this patch which is suitable for 3.16 but might seems confusing a little sine I'm resend the outdated version.
>> If it is a trivial conflict then I think you can just send the patch
>> which applies to the most recent kernel.
>> Greg can clarify if I'm wrong as he maintains the stable trees.
> Please read Documentation/stable_kernel_rules.txt for how to submit
> patches to the stable trees.  Note, it has to be in Linus's tree _first_
> before you ever worry about the stable trees.  Do that first please.
>
> thanks,
>
> greg k-h

